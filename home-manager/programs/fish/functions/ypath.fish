argparse 'hidden' 'root' -- $argv
set fd_args --exclude .git
if set -q _flag_root
    set fd_args $fd_args --exclude proc --exclude sys --exclude dev /
else
    set fd_args $fd_args .
end
if set -q _flag_hidden
    set fd_args --hidden $fd_args
end
set selected (fd $fd_args 2>/dev/null | fzf --prompt="ypath > " --preview="eza --long --all --git --group-directories-first --color=always --icons (dirname {})")
if test -n "$selected"
    echo -n $selected | wl-copy
    echo $selected
end
