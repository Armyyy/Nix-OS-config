{
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # kde-baloo can start before Plasma exports WAYLAND_DISPLAY/DISPLAY to the
  # systemd user env; baloo_file_extractor then aborts (no Qt platform plugin)
  # on every new file. It needs no display, so force the offscreen platform.
  xdg.configFile."systemd/user/kde-baloo.service.d/offscreen.conf".text = ''
    [Service]
    Environment=QT_QPA_PLATFORM=offscreen
  '';
}
