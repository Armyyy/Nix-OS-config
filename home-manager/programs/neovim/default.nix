{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    extraConfig = ''
      set number relativenumber
    '';
    configure = {
      customRC = ''
        set number
      '';
    };
  };
}
