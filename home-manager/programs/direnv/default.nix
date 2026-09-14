{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # kill "direnv: loading ..." / "direnv: export +AR +AS ..." spam
    silent = true;
  };
}
