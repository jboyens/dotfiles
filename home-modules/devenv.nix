{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.devenv.packages."${pkgs.system}".devenv
  ];
}
