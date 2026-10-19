{ pkgs, ... }:
let
  # NECTEC LEXiTRON EN<->TH, raw XML packaged by TLWG
  lexitron-src = pkgs.fetchFromGitHub {
    owner = "tlwg";
    repo = "dict-lexitron";
    rev = "de4c6bc1db5a52bd34f6959d2b76421df4436e65";
    hash = "sha256-w6osZCGB1jEsniWOEFISzCGJf32r7JtuqYlvw8aKhFg=";
  };

  lexitron-stardict = pkgs.runCommand "lexitron-stardict" { nativeBuildInputs = [ pkgs.python3 ]; } ''
    python3 ${./lexitron2stardict.py} etlex ${lexitron-src}/etlex.utf-8 $out "LEXiTRON EN-TH"
    python3 ${./lexitron2stardict.py} telex ${lexitron-src}/telex.utf-8 $out "LEXiTRON TH-EN"
    cp ${lexitron-src}/LICENSE $out/
  '';
in
{
  home.packages = [ pkgs.sdcv ];

  home.file.".stardict/dic/lexitron".source = lexitron-stardict;
}
