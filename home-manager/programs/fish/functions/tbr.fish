set old (tmux list-buffers | cut -d: -f1 | fzf --prompt="rename buffer: " --preview='tmux show-buffer -b {}' --preview-window=right:75% --reverse)
test -z "$old" && return 0

read -l -P "new name: " new
test -z "$new" && return 0

tmux show-buffer -b "$old" | tmux load-buffer -b "$new" -
tmux delete-buffer -b "$old"
echo "renamed $old → $new"
