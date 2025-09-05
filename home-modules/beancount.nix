{
  pkgs,
  inputs,
  ...
}:
let
  unstable-pkgs = inputs.nixpkgs-unstable.legacyPackages."${pkgs.stdenv.hostPlatform.system}";
in
{
  home.packages = [
    # unstable-pkgs.fava
    # unstable-pkgs.beancount
  ];
}
