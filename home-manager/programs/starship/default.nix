{ config, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # we don't use `programs.starship.settings` because it sorts the directory substitions
  # map, but starship requires them to be sorted.
  #
  # https://github.com/starship/starship/issues/5572
  home.file.${config.programs.starship.configPath}.source = ./starship.toml;
}
