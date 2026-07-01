# vi-mode OCaml REPL: rlwrap adds readline editing, INPUTRC scopes vi to here only
env INPUTRC=$HOME/.config/ocaml/inputrc rlwrap -m (type -P ocaml) $argv
