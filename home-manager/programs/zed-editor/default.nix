{ pkgs, ... }:
{
  home.packages = [
    pkgs.nil
    pkgs.texlab
    # TeX distro + latexmk for the LaTeX extension's build-on-save
    (pkgs.texliveSmall.withPackages (ps: [ ps.latexmk ]))
  ];

  xdg.configFile."zed/keymap.json".text = builtins.toJSON [
    {
      bindings = {
        "ctrl-j" = null; # unbind — conflicts with fzf ctrl-j (select next)
      };
    }
    {
      context = "Workspace";
      bindings = {
        "alt-h" = "workspace::ActivatePaneLeft";
        "alt-l" = "workspace::ActivatePaneRight";
        "alt-k" = "workspace::ActivatePaneUp";
        "alt-j" = "workspace::ActivatePaneDown";
      };
    }
    {
      context = "Terminal";
      bindings = {
        # "shift-enter" = [ "terminal::SendText" "\r" ];
        "alt-space" = [
          "terminal::SendText"
          " "
        ];
      };
    }
    {
      context = "AssistantPanel";
      bindings = {
        "escape" = "workspace::ActivatePaneLeft";
      };
    }
    {
      context = "Editor && vim_mode == normal";
      bindings = {
        /*
          "space h" = [
            "tab_switcher::Toggle"
            { select_last = true; }
          ];
          "space l" = "tab_switcher::Toggle";
        */

        "space h" = "pane::ActivatePreviousItem";
        "space l" = "pane::ActivateNextItem";
        "space w" = "editor::ToggleSoftWrap";
        "space f" = "settings_profile_selector::Toggle";
      };
    }
  ];

  xdg.configFile."zed/themes/ayu.json".source = ./themes/ayu.json;
  xdg.configFile."zed/themes/baby-blue.json".source = ./themes/baby-blue.json;
  xdg.configFile."zed/themes/cool-panda.json".source = ./themes/cool-panda.json;
  xdg.configFile."zed/themes/dark-death.json".source = ./themes/dark-death.json;
  xdg.configFile."zed/themes/gitlab-light.json".source = ./themes/gitlab-light.json;
  xdg.configFile."zed/themes/minimalist-purple.json".source = ./themes/minimalist-purple.json;
  xdg.configFile."zed/themes/neo-dark-horizon.json".source = ./themes/neo-dark-horizon.json;
  xdg.configFile."zed/themes/nu-disco.json".source = ./themes/nu-disco.json;
  xdg.configFile."zed/themes/srds-synthwave.json".source = ./themes/srds-synthwave.json;
  xdg.configFile."zed/themes/wildberries.json".source = ./themes/wildberries.json;

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "rainbow-csv"
      "typst"
      "latex"
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

      # LSP code lens: "off" | "on" (above the line) | "menu" (in code action menu)
      code_lens = "on";

      diagnostics = {
        inline = {
          enabled = true;
        };
      };

      "experimental.theme_overrides" = {
        "terminal.background" = "#000000";
        "search.match_background" = "#ae56e940"; # word-width box on all matches
        # "editor.active_line.background" = "#3d2040"; # visible row highlight on cursor line
      };

      gutter = {
        line_numbers = false;
        runnables = false; # Disable runnable/test buttons
        breakpoints = false; # Hide breakpoint markers
        folds = false; # Remove fold arrows
        bookmarks = false;
        # min_line_number_digits = 2; # comment this out for left most
      };

      icon_theme = "Material Icon Theme";

      inline_code_actions = true;

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

      # pick via `space f` (settings_profile_selector); "Disabled" = back to base
      # base "user" (default) = applied on top of these userSettings
      profiles = {
        "No Tabs" = {
          settings = {
            tab_bar.show = false;

            title_bar = {
              show_branch_name = false;
              show_worktree_name = false;
              show_project_items = false;
              show_onboarding_banner = false;
              show_user_picture = false;
              show_user_menu = false;
              show_sign_in = false;
            };

            toolbar = {
              breadcrumbs = false;
              quick_actions = false;
              selections_menu = false;
              agent_review = false;
              code_actions = false;
            };

            # keep status bar for the full file path, drop everything else
            status_bar = {
              active_language_button = false;
              cursor_position_button = false;
            };
            project_panel.button = false;
            outline_panel.button = false;
            collaboration_panel.button = false;
            git_panel.button = false;
            # agent off = no Threads Sidebar toggle in status bar (no setting for it alone)
            agent = {
              enabled = false;
              button = false;
            };
            diagnostics.button = false;
            terminal.button = false;
            debugger.button = false;
            search.button = false;

            scrollbar.show = "never";
            indent_guides.enabled = false;
            show_wrap_guides = false;
            code_lens = "off";
            inline_code_actions = false;
            global_lsp_settings.button = false;
            # provider "none" = no Edit Prediction button in status bar
            edit_predictions.provider = "none";
            diagnostics.inline.enabled = false;
            git = {
              git_gutter = "hide";
              inline_blame.enabled = false;
            };
          };
        };
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
      theme = "Dark Death";
      # theme = "GitLab Light";
      # theme = "Minimalist Purple";
      # theme = "Neo Dark Horizon";
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

      wrap_guides = [ 80 ];
      show_wrap_guides = true;

      languages = {
        "Plain Text" = {
          soft_wrap = "none"; # No visual line wrap, scroll horizontally instead
        };
      };

      lsp = {
        nil = {
          binary.path = "${pkgs.nil}/bin/nil";
        };
        # use nix ocamllsp directly, bypass Zed's opam wrapper (no switch needed)
        # server id is "ocamllsp" (per Zed error), NOT "ocaml-lsp"
        ocamllsp = {
          binary = {
            path = "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp";
            arguments = [ ];
          };
        };
        # LaTeX extension downloads a prebuilt texlab that won't run on NixOS
        texlab = {
          binary = {
            path = "${pkgs.texlab}/bin/texlab";
            arguments = [ ];
          };
          settings.texlab = {
            build = {
              onSave = true;
              forwardSearchAfter = false; # compile only, never open a viewer
              executable = "latexmk";
              args = [
                "-pdf"
                "-interaction=nonstopmode"
                "-synctex=1"
                "%f"
              ];
            };
            # empty forwardSearch: stops the extension from autoconfiguring a
            # PDF viewer and launching it on save
            forwardSearch = { };
          };
        };
      };
    };
  };
}
