{
  inputs,
  pkgs,
  ...
}:
{
  # attribute set: x = { a=1; b=2; ... };
  #
  # y = x.a;
  #
  # with x;
  #
  # y = a;
  home.packages = [
    inputs.stm32cubeide.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
