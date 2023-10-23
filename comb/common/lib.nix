{
  inputs,
  cell,
}: let
  lib = inputs.nixpkgs.lib // builtins;
in
  lib
