# cdf - cd to a directory using fzf and eza
set selected (fd --hidden --exclude .git . $HOME 2>/dev/null | fzf --prompt="cd > " --preview="eza --long --all --git --group-directories-first --color=always --icons (dirname {})")
if test -n "$selected"
    if test -d "$selected"
        cd $selected
    else
        cd (dirname $selected)
    end
end
