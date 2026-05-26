{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    keyMode = "vi";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
