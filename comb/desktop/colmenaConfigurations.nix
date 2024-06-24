{
  inputs,
  cell,
}: let
  common = {
    bee.system = "x86_64-linux";
    bee.pkgs = inputs.cells.common.pkgs;
    deployment = {
      allowLocalDeployment = true;
      tags = ["all"];
    };
  };
in {
  bishop = {
    imports = [cell.nixosConfigurations.bishop];
    inherit (common) bee;

    deployment = common.deployment // {tags = ["desktops"];};
  };
}
