{
  inputs,
  cell,
}: let
  pkgs = import inputs.nixpkgs {
    overlays = [
      inputs.nixpkgs-wayland.overlay
      inputs.emacs-overlay.overlay
    ];
  };
in
  pkgs
