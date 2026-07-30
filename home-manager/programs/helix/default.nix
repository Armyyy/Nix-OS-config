{
  pkgs,
  config,
  inputs,
  ...
}:
let
  steelHome = "${config.home.homeDirectory}/.steel";
in
{
  home.packages = [ pkgs.nil ];

  # Steel plugin engine root. steelix self-writes helix/*.scm cogs here on
  # startup, so it must be a real writable dir (not the nix store).
  home.sessionVariables.STEEL_HOME = steelHome;

  # vim.hx cog (real vim modal editing). Symlinked read-only from the store;
  # steelix still writes its own cogs/helix beside it.
  home.file.".steel/cogs/vim-hx".source = inputs.vim-hx;

  # Steel entry point. Loads vim.hx and switches on the vim keymap.
  xdg.configFile."helix/init.scm".text = ''
    (require "vim-hx/init.scm")
    (set-vim-keybindings!)
  '';

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs.steelix;

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
