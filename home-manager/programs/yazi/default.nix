{ pkgs, lib, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    initLua = ./init.lua;
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
    };
    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 65535;
        max_height = 65535;
      };
    };
  };
  programs.fish.functions.yy = lib.mkForce {
    description = "yazi file manager, cd into dir on exit";
    body = ''
      set -l tmp (mktemp -t "yazi-cwd.XXXXX")
      command yazi $argv --cwd-file="$tmp"
      if read cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
      end
      rm -f -- "$tmp"
    '';
  };
}
