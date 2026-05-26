{ pkgs, ... }:
{
  home.packages = [ pkgs.nil ];

  xdg.configFile."zed/themes/ayu.json".source = ./themes/ayu.json;
  xdg.configFile."zed/themes/baby-blue.json".source = ./themes/baby-blue.json;
  xdg.configFile."zed/themes/cool-panda.json".source = ./themes/cool-panda.json;
  xdg.configFile."zed/themes/dark-death.json".source = ./themes/dark-death.json;
  xdg.configFile."zed/themes/minimalist-purple.json".source = ./themes/minimalist-purple.json;
  xdg.configFile."zed/themes/neo-dark-horizon.json".source = ./themes/neo-dark-horizon.json;
  xdg.configFile."zed/themes/nu-disco.json".source = ./themes/nu-disco.json;
  xdg.configFile."zed/themes/srds-synthwave.json".source = ./themes/srds-synthwave.json;
  xdg.configFile."zed/themes/wildberries.json".source = ./themes/wildberries.json;

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
      buffer_font_weight = 300;
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
        line_numbers = false;
        runnables = false; # Disable runnable/test buttons
        breakpoints = false; # Hide breakpoint markers
        folds = false; # Remove fold arrows
        # min_line_number_digits = 2; # comment this out for left most
      };

      icon_theme = "Material Icon Theme";

      inline_code_actions = true;

      features = {
        edit_prediction_provider = "zed";
      };

      project_panel = {
        default_width = 400;
        dock = "right";
        entry_spacing = "standard";
        indent_size = 20;
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

      tab_bar = {
        show = true;
      };

      status_bar = {
        show_active_file = true;
      };

      terminal = {
        default_height = 600;
        font_size = 12;
        font_family = "JetBrainsMono Nerd Font";
        font_weight = 300;
        line_height = {
          custom = 1.1;
        };
      };

      ### included themes
      # theme = "Catppuccin Mocha";
      # theme = "Tokyo Night";
      # theme = "One Dark Pro";
      # theme = "The Dark Side";
      # theme = "Smooth Dark";

      ### installed custom themes
      # theme = "Ayu Dark";
      # theme = "Baby Blue";
      # theme = "Cool Panda";
      # theme = "Dark Death";
      # theme = "Minimalist Purple";
      theme = "Neo Dark Horizon";
      # theme = "Nu Disco";
      # theme = "SRD's Synthwave Dark";
      # theme = "Wildberries Darker";

      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };

      ui_font_family = "JetBrainsMono Nerd Font";
      ui_font_size = 16;

      vim_mode = true;

      vertical_scroll_margin = 0;

      lsp = {
        nil = {
          binary.path = "${pkgs.nil}/bin/nil";
        };
      };
    };
  };
}
