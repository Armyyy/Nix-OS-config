{ ... }:
{
  programs.claude-code = {
    enable = true;
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

  # home.file.".claude/settings.json".source = ./settings.json;
}
