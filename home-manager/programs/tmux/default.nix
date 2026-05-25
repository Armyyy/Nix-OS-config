{ config, ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
