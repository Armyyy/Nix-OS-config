{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
    # ~/.config/zed/settings.json
    userSettings = {

      auto_install_extensions = {
        nix = true;
      };

      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_features = {
        calt = false;
      };
      buffer_font_size = 16;
      buffer_font_weight = 200;
      buffer_line_height = {
        custom = 1.2;
      };

      diagnostics = {
        inline = {
          enabled = true;
        };
      };

      "experimental.theme_overrides" = {
        "terminal.background" = "#000000";
      };

      gutter = {
        line_numbers = true;
        runnables = false; # Disable runnable/test buttons
        breakpoints = false; # Hide breakpoint markers
        folds = false; # Remove fold arrows
        min_line_number_digits = 2;
      };

      icon_theme = "Catppuccin Mocha";

      inline_code_actions = true;

      project_panel = {
        default_width = 110;
        dock = "right";
        entry_spacing = "standard";
        indent_size = 10;
      };

      relative_line_numbers = "disabled";

      scrollbar = {
        axes = {
          horizontal = false;
          vertical = true;
        };
      };

      show_completions_on_input = true;

      tabs = {
        file_icons = true;
        git_status = true;
        show_close_button = "hidden";
        show_diagnostics = "all";
      };

      terminal = {
        font_size = 12;
        font_family = "JetBrainsMono Nerd Font";
        font_weight = 100;
        line_height = {
          custom = 1.2;
        };
      };

      theme = "Tokyo Night";

      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };

      ui_font_family = ".ZedSans";
      ui_font_size = 14;

      vim_mode = false;

    };
  };
}
