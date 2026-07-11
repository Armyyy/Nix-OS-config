{ pkgs, ... }:
{
  home.packages = [ pkgs.tgpt ];

  # tgpt default provider (phind + sky broken; pollinations works, keyless)
  home.sessionVariables.AI_PROVIDER = "pollinations";
}
