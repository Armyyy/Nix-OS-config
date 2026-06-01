# fipre - find and preview files using fzf and bat
rg --files | fzf --preview 'bat --color=always {}'
