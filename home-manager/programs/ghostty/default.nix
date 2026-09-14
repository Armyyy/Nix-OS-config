{
  lib,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      window-decoration = "none";

      background = "000000";
      background-image = "/home/army/Pictures/Castorice/the_pink_team.1.jpg";
      background-image-opacity = 0.008;
      background-image-fit = "cover";

      selection-foreground = "cell-background";
      selection-background = "cell-foreground";

      custom-shader = "/home/army/Documents/nix-config/home-manager/programs/ghostty/shaders/cursor-blaze.glsl";
    };
  };

  # KWin script that snaps new Ghostty windows to the right half of their screen.
  # A Wayland session looks for scripts under kwin-wayland/, not kwin/.
  xdg.dataFile."kwin-wayland/scripts/ghostty-tile" = {
    source = ./kwin-script;
    recursive = true;
  };

  # kwinrc is owned and rewritten by Plasma, so the plugin is toggled with
  # kwriteconfig6 instead of being managed as a file.
  home.activation.enableGhosttyKwinScript = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kwinrc --group Plugins --key ghostty-tileEnabled true

    if [ -n "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      run ${pkgs.systemd}/bin/busctl --user call \
        org.kde.KWin /KWin org.kde.KWin reconfigure || true
    fi
  '';
}
