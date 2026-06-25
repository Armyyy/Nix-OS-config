{ pkgs, ... }:
{
  home.packages = [
    pkgs.ocaml
    pkgs.ocamlPackages.utop # REPL with readline + history
    pkgs.ocamlPackages.ocaml-lsp # editor autocomplete, type-on-hover, errors
    pkgs.ocamlPackages.ocamlformat # auto-format, dune calls it
    pkgs.ocamlPackages.findlib # ocamlfind, lib resolution for dune
  ];
}
