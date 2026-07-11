{ pkgs, ... }:
{
  home.packages = [ pkgs.nil ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    # custom theme: inherit default, brighten cursor crosshair bg
    themes.custom = {
      inherits = "default";
      "ui.cursorline.primary".bg = "#393556";
      "ui.cursorcolumn.primary".bg = "#393556";
    };

    settings = {
      theme = "custom";
      editor = {
        line-number = "relative";
        cursorline = true;
        cursorcolumn = true;
        bufferline = "multiple";
        color-modes = true;
        true-color = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };

      # ---- vim-style keybindings ----
      # Helix is selection-first (kakoune model); these remaps make motions
      # and edits behave like vim (motion-then-verb, 0/$/G, dd/yy/cw, D/C).
      keys.normal = {
        # line motions
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        "G" = "goto_last_line";
        "%" = "match_brackets";

        # vim D / C: act to end of line
        "D" = [
          "extend_to_line_end"
          "delete_selection"
        ];
        "C" = [
          "extend_to_line_end"
          "change_selection"
        ];

        # vim x: delete char under cursor (no line-select first)
        "x" = "delete_selection";

        # redo like vim
        "C-r" = "redo";

        # gg -> file start
        g.g = "goto_file_start";

        # d + motion (vim operator-pending emulation)
        d = {
          d = [
            "extend_to_line_bounds"
            "delete_selection"
          ];
          w = [
            "move_next_word_start"
            "delete_selection"
          ];
          e = [
            "move_next_word_end"
            "delete_selection"
          ];
          b = [
            "move_prev_word_start"
            "delete_selection"
          ];
          "$" = [
            "extend_to_line_end"
            "delete_selection"
          ];
          "0" = [
            "extend_to_line_start"
            "delete_selection"
          ];
        };

        # c + motion
        c = {
          c = [
            "extend_to_line_bounds"
            "change_selection"
          ];
          w = [
            "move_next_word_start"
            "change_selection"
          ];
          e = [
            "move_next_word_end"
            "change_selection"
          ];
          b = [
            "move_prev_word_start"
            "change_selection"
          ];
          "$" = [
            "extend_to_line_end"
            "change_selection"
          ];
        };

        # y + motion (yank)
        y = {
          y = [
            "extend_to_line_bounds"
            "yank"
            "collapse_selection"
          ];
          w = [
            "move_next_word_start"
            "yank"
            "collapse_selection"
          ];
        };
      };

      keys.select = {
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        "G" = "goto_last_line";
        g.g = "goto_file_start";
      };
    };

    languages = {
      language-server.nil = {
        command = "${pkgs.nil}/bin/nil";
      };
      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          auto-format = true;
        }
        {
          # helix ships rulers [50 72] for git commits; drop the guide lines
          name = "git-commit";
          rulers = [ ];
          text-width = 72;
        }
      ];
    };
  };
}
