{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {packages = [nixpkgs.gnupg];}
