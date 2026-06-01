{
  # eza
  ls = "eza --tree --level=1";

  # tmux
  # git
  gst = "git status";
  gaa = "git add -A";
  glo = "git log --oneline";

  # docker
  drm = "docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)";
}
