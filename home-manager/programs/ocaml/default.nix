{ pkgs, ... }:
{
  home.packages = [
    pkgs.ocaml
    pkgs.ocamlPackages.utop # REPL with readline + history
    pkgs.ocamlPackages.ocaml-lsp # editor autocomplete, type-on-hover, errors
    pkgs.ocamlPackages.ocamlformat # auto-format, dune calls it
    pkgs.ocamlPackages.findlib # ocamlfind, lib resolution for dune
    pkgs.rlwrap # readline wrapper, gives `ocaml` REPL vi-mode editing
    pkgs.opam # OCaml package manager (own switches/compilers, parallel to nix)
  ];

  home.file.".config/utop/init.ml".text = ''
    UTop.set_show_box false;;
    #use "topfind";;
    Topfind.log := ignore;;
  '';

  # scoped vi keys for the rlwrap'd `ocaml` REPL only (see fish ocaml function)
  home.file.".config/ocaml/inputrc".text = ''
    set editing-mode vi
    set show-mode-in-prompt on
  '';
}
