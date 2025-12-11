{ pkgs, ... }:
{
  home.packages = with pkgs; [
    oh-my-posh
  ];
}
