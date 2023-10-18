{
  inputs,
  cell,
}: let
  inherit (inputs.nixos-generators) nixosGenerate;
in rec {
  default = install-iso;
  install-iso = nixosGenerate {
    pkgs = inputs.nixpkgs;
    modules =
      [{isoImage.isoName = cell.lib.mkForce "laptop.iso";}]
      ++ inputs.cells.homebase.nixosSuites.default;
    format = "install-iso";
  };
}
