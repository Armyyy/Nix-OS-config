{
  pkgs,
  ...
}:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    colors = "always";
    git = true;
    icons = "always";

    extraOptions = [
      "-lah"
      "--group-directories-first"
      "--colour-scale"
    ];
  };

  xdg.configFile."eza/theme.yml".source =
    let
      repo = pkgs.fetchFromGitHub {
        owner = "eza-community";
        repo = "eza-themes";
        rev = "17095bff4792eecd7f4f1ed8301b15000331c906";
        hash = "sha256-2WTbCQlhwMo5cOn3KwtNiIst0tNfASfZnPNsNBs+gcU=";
      };
    in
    "${repo}/themes/tokyonight.yml";
}
