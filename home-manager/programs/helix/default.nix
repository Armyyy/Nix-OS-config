{
  pkgs,
  config,
  inputs,
  ...
}:
let
  steelHome = "${config.home.homeDirectory}/.steel";

  # nixpkgs pairs helix's rust highlight queries with an older tree-sitter-rust
  # grammar that has no `type_parameter` node. tree-sitter refuses to compile the
  # whole query file over one bad pattern, so *all* rust highlighting dies and
  # every token renders in the default fg. Drop the two offending lines; the only
  # loss is @type.parameter on generic parameter declarations.
  rustHighlights = pkgs.runCommand "helix-rust-highlights" { } ''
    mkdir -p $out
    sed '/^(type_parameter$/,+1d' \
      ${pkgs.steelix.runtime}/queries/rust/highlights.scm > $out/highlights.scm
  '';
in
{
  home.packages = [ pkgs.nil ];

  # Steel plugin engine root. steelix self-writes helix/*.scm cogs here on
  # startup, so it must be a real writable dir (not the nix store).
  home.sessionVariables.STEEL_HOME = steelHome;

  # vim.hx cog (real vim modal editing). Symlinked read-only from the store;
  # steelix still writes its own cogs/helix beside it.
  home.file.".steel/cogs/vim-hx".source = inputs.vim-hx;

  # Config-dir runtime wins over $HELIX_RUNTIME, per query file.
  xdg.configFile."helix/runtime/queries/rust/highlights.scm".source =
    "${rustHighlights}/highlights.scm";

  # nixpkgs' helix-runtime ships grammars + queries only, no themes, so the only
  # themes steelix can see are the two compiled into the binary (default,
  # base16_theme). Pull the ~174 upstream themes back in. Not `themes/` — that
  # dir is owned by programs.helix.themes for custom.toml.
  xdg.configFile."helix/runtime/themes".source =
    "${pkgs.helix-unwrapped.src}/runtime/themes";

  # Steel entry point. Loads vim.hx and switches on the vim keymap.
  xdg.configFile."helix/init.scm".text = ''
    (require "vim-hx/init.scm")
    (set-vim-keybindings!)
  '';

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs.steelix;

    # custom theme: inherit default, black bg, brighten cursor crosshair bg
    themes.custom = {
      inherits = "default";
      "ui.background".bg = "#000000";
      "ui.cursorline.primary".bg = "#393556";
      "ui.cursorcolumn.primary".bg = "#393556";
    };

    settings = {
      theme = "custom";
      editor = {
        line-number = "relative";
        # drop the line-number column (and the rest of the default gutter set:
        # diff, spacer, ...); keep only the diagnostic dots
        gutters = [ "diagnostics" ];
        cursorline = true;
        cursorcolumn = true;
        bufferline = "multiple";
        # zed's wrap_guides = [80] draws a hairline after the 80th char. helix
        # has no hairline — it tints a whole cell — so use 81: the tinted column
        # is the first one past 80, starting at the same x as zed's guide.
        rulers = [ 81 ];
        color-modes = true;
        true-color = true;
        # steelix-only: trust every workspace implicitly, killing the
        # "Trust this workspace?" prompt. Trusted workspaces auto-start
        # language servers and load local config, both of which can run
        # arbitrary code.
        workspace-trust.level = "insecure";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
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
