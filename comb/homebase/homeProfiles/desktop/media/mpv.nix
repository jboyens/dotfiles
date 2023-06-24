{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    # mpv-with-scripts
    mpv
    mpvc # CLI controller for mpv
  ];
}
