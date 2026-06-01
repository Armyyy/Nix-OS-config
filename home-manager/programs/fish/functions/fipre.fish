# fipre - find and preview files using fzf and bat
argparse 'hidden' 'zed' -- $argv
set rg_args --files
if set -q _flag_hidden
    set rg_args $rg_args --hidden
end
set selected (rg $rg_args | fzf --preview 'bat --color=always {}')
if test -n "$selected"
    if set -q _flag_zed
        zeditor $selected
    end
end
