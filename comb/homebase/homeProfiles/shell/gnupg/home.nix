{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {packages = [cell.packages.gnupg];}
