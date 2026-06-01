# fipre - find and preview files using fzf and bat
rg --files --hidden | fzf --preview 'bat --color=always {}'
