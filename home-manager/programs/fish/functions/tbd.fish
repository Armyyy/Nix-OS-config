for buf in (tmux list-buffers | cut -d: -f1 | fzf --multi --prompt="delete buffers: " --preview='tmux show-buffer -b {}' --preview-window=right:75% --reverse)
    tmux delete-buffer -b $buf
    echo "deleted $buf"
end
