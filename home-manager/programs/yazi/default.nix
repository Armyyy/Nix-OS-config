{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
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
}
