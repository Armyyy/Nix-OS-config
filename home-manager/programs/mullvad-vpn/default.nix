{ pkgs, ... }:
{
  programs.mullvad-vpn = {
    enable = true;
  };

  # Custom launcher entry (own icon). Exec is derived from the package so it
  # never points at a garbage-collected store path after an update.
  xdg.desktopEntries.mullvad-vpn = {
    name = "Mullvad";
    comment = "Mullvad VPN client";
    exec = "${pkgs.mullvad-vpn}/bin/mullvad-vpn";
    icon = "/home/army/Pictures/logos-icons/mullvad-vpn-logo(1).png";
    categories = [ "Network" ];
    terminal = false;
    type = "Application";
    startupNotify = true;
    settings = {
      StartupWMClass = "Mullvad VPN";
    };
  };
}
