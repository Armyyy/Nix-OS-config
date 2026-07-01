{ ... }:
{
  # Sober (Roblox) is installed as a flatpak (see nixos/configuration.nix).
  # Its bundled GTK/Pango + cairo cannot instantiate variable fonts, so any
  # text that resolves to NixOS's variable Noto fonts (e.g. NotoSans[wdth,wght].ttf)
  # renders as tofu boxes. Give Sober a per-app fontconfig that rejects variable
  # font files, forcing fc-match onto the static NotoSans.ttf / NotoSansThai.ttf
  # that noto-fonts also ships.
  home.file.".var/app/org.vinegarhq.Sober/config/fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <selectfont>
        <rejectfont>
          <glob>*wght*.ttf</glob>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
}
