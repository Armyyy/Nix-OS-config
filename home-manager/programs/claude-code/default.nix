{ pkgs, config, ... }:
{
  home.packages = [ pkgs.nodejs ];

  programs.claude-code = {
    enable = true;

    settings = {
      model = "sonnet";
      alwaysThinkingEnabled = true;
      effortLevel = "high";
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
