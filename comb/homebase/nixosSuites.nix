{
  inputs,
  cell,
}: let
  lib = builtins // inputs.nixpkgs.lib // cell.lib;
in {
  default = [
    cell.nixosProfiles.everything
  ];
}
