# hclean - clean fish history using fzf
for entry in (history | fzf --multi)
  builtin history delete --case-sensitive -- $entry
end
