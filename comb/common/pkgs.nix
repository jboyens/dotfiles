{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs {
    overlays = [inputs.nixpkgs-wayland.overlay];
  };
in
  pkgs
