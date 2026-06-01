{
  # eza
  ls = "eza --tree --level=1 -a";

  # tmux
  # git
  gst = "git status";
  gaa = "git add -A";
  glo = "git log --oneline";
  gcm = "git commit -m ";

  # docker
  drm = "docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)";
}
