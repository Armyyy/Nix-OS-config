{
  programs.fish = {
    enable = true;
    shellInit = ''
      # tgpt default provider (phind is broken, sky works)
      set -gx AI_PROVIDER sky
    '';
  };
}
