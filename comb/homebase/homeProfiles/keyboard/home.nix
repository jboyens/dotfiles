{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  packages = [nixpkgs.wally-cli];
}
