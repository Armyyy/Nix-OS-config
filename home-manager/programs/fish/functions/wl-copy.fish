# wl-copy forks a background daemon that keeps stderr on the calling tty.
# Inside a tmux popup that fd keeps the pty alive, so the popup never gets EOF
# and refuses to close. Detach stderr so the popup can exit.
command wl-copy $argv 2>/dev/null
