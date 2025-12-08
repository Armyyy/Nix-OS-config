{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
    # ~/.config/zed/settings.json
    userSettings = {
      vim_mode = false;
      diagnostics = {
        inline = {
          enabled = true;
        };
      };
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
      };
      buffer_font_family = "JetBrainsMono Nerd Font";
      ui_font_family = ".ZedSans";
      inline_code_actions = true;
      gutter = {
        breakpoints = true;
        min_line_number_digits = 2;
        line_numbers = true;
      };
      relative_line_numbers = "enabled";
      project_panel = {
        dock = "right";
        entry_spacing = "standard";
      };
      tabs = {
        file_icons = true;
      };
      ui_font_size = 14;
      buffer_font_size = 16;
      buffer_line_height = {
        custom = 1.4;
      };
      buffer_font_features = {
        calt = false;
      };
      buffer_font_weight = 200;
      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };
      theme = "Tokyo Night";
      icon_theme = "Catppuccin Mocha";
      auto_install_extensions = {
        nix = true;
      };
      show_completions_on_input = true;
    };
  };
}
