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
        font_size = 12;
        font_family = "JetBrainsMono Nerd Font";
        font_weight = 100;
        line_height = {
          custom = 1.2;
        };
      };
      buffer_font_family = "JetBrainsMono Nerd Font";
      ui_font_family = ".ZedSans";
      inline_code_actions = true;
      gutter = {
        line_numbers = true;
        runnables = false; # Disable runnable/test buttons
        breakpoints = false; # Hide breakpoint markers
        folds = false; # Remove fold arrows
        min_line_number_digits = 2;
      };
      relative_line_numbers = "disabled";
      project_panel = {
        default_width = 110;
        dock = "right";
        entry_spacing = "standard";
        indent_size = 10;
      };
      tabs = {
        file_icons = true;
        git_status = true;
        show_close_button = "hidden";
        show_diagnostics = "all";
      };
      ui_font_size = 14;
      buffer_font_size = 16;
      buffer_line_height = {
        custom = 1.2;
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
      scrollbar = {
        axes = {
          horizontal = false;
          vertical = true;
        };
      };
    };
  };
}
