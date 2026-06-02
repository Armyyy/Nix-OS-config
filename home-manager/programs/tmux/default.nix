{ pkgs, ... }:
let
  cpu = pkgs.tmuxPlugins.cpu;
in
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    keyMode = "vi";
    extraConfig = (builtins.readFile ./tmux.conf) + ''
      run-shell ${cpu.rtp}
    '';
  };
}
