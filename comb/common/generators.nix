{
  inputs,
  cell,
}: let
  inherit (inputs.nixos-generators) nixosGenerate;
in rec {
  default = install-iso;
  install-iso = nixosGenerate {
    inherit (cell) pkgs;
    modules =
      [
        {
          isoImage.isoName = cell.lib.mkForce "laptop.iso";
          virtualisation.docker.enableNvidia = cell.lib.mkForce false;
        }
      ]
      ++ inputs.cells.laptop.nixosSuites.default;
    format = "install-iso";
  };
}
