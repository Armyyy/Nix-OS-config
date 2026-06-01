{ pkgs, ... }:
{
  home.packages = [ pkgs.csvlens pkgs.miller pkgs.python3 ];
}
