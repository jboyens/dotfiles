{
  inputs,
  cell,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";

    overlays = [
      inputs.nixpkgs-wayland.overlay
      inputs.emacs-overlay.overlay
      # inputs.hyprland.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
in
  pkgs
