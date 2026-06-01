# fipre - find and preview files using fzf and bat
argparse 'hidden' -- $argv
set rg_args --files
if set -q _flag_hidden
    set rg_args $rg_args --hidden
end
rg $rg_args | fzf --preview 'bat --color=always {}'
