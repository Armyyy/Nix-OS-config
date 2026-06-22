{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Custom statusline. Reads session JSON on stdin (Claude Code >=2.1) and the
  # caveman flag file, renders:
  #   [CAVEMAN] │ 🔌 mcp,names │ Model │ 5h NN% ↻HH:MM │ 🧠 NN%
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    set -u
    input=$(cat)
    jq="${pkgs.jq}/bin/jq"
    date="${pkgs.coreutils}/bin/date"

    field() { printf '%s' "$input" | "$jq" -r "$1" 2>/dev/null; }

    model=$(field '.model.display_name // "?"')
    ctx=$(field '.context_window.used_percentage // empty')
    fh_pct=$(field '.rate_limits.five_hour.used_percentage // empty')
    fh_reset=$(field '.rate_limits.five_hour.resets_at // empty')

    sep=$'\033[38;5;240m│\033[0m'
    parts=""
    add() { if [ -n "$parts" ]; then parts="$parts $sep $1"; else parts="$1"; fi; }

    # CAVEMAN badge — read flag, refuse symlinks, whitelist + strip control bytes
    FLAG="''${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
    if [ -f "$FLAG" ] && [ ! -L "$FLAG" ]; then
      mode=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
      case "$mode" in
        off | "") ;;
        full)    add $'\033[38;5;172m[CAVEMAN]\033[0m' ;;
        lite | ultra | wenyan-lite | wenyan | wenyan-full | wenyan-ultra | commit | review | compress)
          up=$(printf '%s' "$mode" | tr '[:lower:]' '[:upper:]')
          add $'\033[38;5;172m[CAVEMAN:'"$up"$']\033[0m' ;;
      esac
    fi

    # Active MCP servers (global config)
    mcp=$("$jq" -r '(.mcpServers // {}) | keys | join(",")' "$HOME/.claude.json" 2>/dev/null)
    [ -n "$mcp" ] && add $'\033[38;5;39m🔌 '"$mcp"$'\033[0m'

    # Model
    add $'\033[38;5;213m'"$model"$'\033[0m'

    # 5-hour rate-limit window: used % + reset clock (24h)
    if [ -n "$fh_pct" ]; then
      pct=$(printf '%.0f' "$fh_pct" 2>/dev/null)
      reset=""
      [ -n "$fh_reset" ] && reset=$("$date" -d "@$fh_reset" +%H:%M 2>/dev/null)
      add $'\033[38;5;220m'"$pct"$'%'"''${reset:+ ↻ $reset}"$'\033[0m'
    fi

    # Context window progress
    [ -n "$ctx" ] && add $'\033[38;5;82m🧠 '"$ctx"$'%\033[0m'

    printf '%s' "$parts"
  '';

  claudeSettings = {
    model = "opus";
    alwaysThinkingEnabled = true;
    editorMode = "vim";
    permissions = {
      defaultMode = "bypassPermissions";
    };
    enabledPlugins = {
      "caveman@caveman" = true;
      "gopls-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
    };
    hooks = {
      SessionStart = [
        {
          hooks = [
            {
              type = "command";
              command = "${pkgs.nodejs}/bin/node ${config.home.homeDirectory}/.claude/hooks/caveman-activate.js";
              timeout = 5;
              statusMessage = "Loading caveman mode...";
            }
          ];
        }
      ];
      UserPromptSubmit = [
        {
          hooks = [
            {
              type = "command";
              command = "${pkgs.nodejs}/bin/node ${config.home.homeDirectory}/.claude/hooks/caveman-mode-tracker.js";
              timeout = 5;
              statusMessage = "Tracking caveman mode...";
            }
          ];
        }
      ];
    };
    statusLine = {
      type = "command";
      command = "${statuslineScript}";
    };
  };
  claudeSettingsFile = pkgs.writeText "claude-settings.json" (builtins.toJSON claudeSettings);
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.uv
  ];

  home.activation.headroomMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_JSON="$HOME/.claude.json"
    if [ -f "$CLAUDE_JSON" ]; then
      ${pkgs.jq}/bin/jq --arg cmd "${pkgs.uv}/bin/uvx" \
        '.mcpServers.headroom = {"type":"stdio","command":$cmd,"args":["--from","headroom-ai[mcp]","headroom","mcp","serve"],"env":{"NIX_LD_LIBRARY_PATH":"/run/current-system/sw/share/nix-ld/lib","LD_LIBRARY_PATH":"/run/current-system/sw/share/nix-ld/lib"}}' \
        "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
    fi
  '';

  # Write settings.json as a real file (not a Nix store symlink) so Claude Code
  # can write runtime overrides like effortLevel. Preserves effortLevel across switches.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS="$HOME/.claude/settings.json"

    # Replace symlink from previous Nix management with real file
    [ -L "$SETTINGS" ] && rm "$SETTINGS"

    if [ -f "$SETTINGS" ]; then
      EFFORT=$(${pkgs.jq}/bin/jq -r '.effortLevel // empty' "$SETTINGS")
      if [ -n "$EFFORT" ]; then
        ${pkgs.jq}/bin/jq --arg e "$EFFORT" '.effortLevel = $e' ${claudeSettingsFile} > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
      else
        cp ${claudeSettingsFile} "$SETTINGS"
      fi
    else
      cp ${claudeSettingsFile} "$SETTINGS"
    fi

    chmod 644 "$SETTINGS"
  '';

  programs.claude-code = {
    enable = true;
    # settings managed via home.activation.claudeSettings to keep file writable
  };

  home.file.".claude/keybindings.json".text = builtins.toJSON {
    "\$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
    "\$docs" = "https://code.claude.com/docs/en/keybindings";
    bindings = [
      {
        context = "Chat";
        bindings = {
          "shift+enter" = "chat:newline";
        };
      }
    ];
  };
}
