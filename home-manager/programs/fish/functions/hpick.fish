# hpick - pick a command from fish history using fzf or peco
if test "$argv[1]" = "--peco"
  history | peco | wl-copy
else
  history | fzf | wl-copy
end
