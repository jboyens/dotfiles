{
  inputs,
  cell,
}: let
  inherit (cell) pkgs;
in {
  home.packages = [
    pkgs.hyprland
  ];
}
