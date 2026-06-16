{
  pkgs,
  config,
  lib,
  ...
}:
let
  claudeSettings = {
    model = "opus";
    alwaysThinkingEnabled = true;
    editorMode = "vim";
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
      command = "bash ${config.home.homeDirectory}/.claude/hooks/caveman-statusline.sh";
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
