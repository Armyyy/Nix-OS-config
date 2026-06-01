# cdf - cd to a directory using fzf and eza
argparse 'hidden' -- $argv
set fd_args --exclude .git . $HOME
if set -q _flag_hidden
    set fd_args --hidden $fd_args
end
set selected (fd $fd_args 2>/dev/null | fzf --prompt="cd > " --preview="eza --long --all --git --group-directories-first --color=always --icons (dirname {})")
if test -n "$selected"
    if test -d "$selected"
        cd $selected
    else
        cd (dirname $selected)
    end
end
