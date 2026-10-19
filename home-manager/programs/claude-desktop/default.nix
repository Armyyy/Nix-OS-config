{inputs,  pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.claude-desktop.overlays.default ];

  home.packages = with pkgs; [
    claude-desktop
  ];
}
