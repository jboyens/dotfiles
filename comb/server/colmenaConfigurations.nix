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
  tinman = {
    inherit (common) bee;

    imports = [cell.nixosConfigurations.tinman];

    deployment =
      common.deployment
      // {
        targetHost = "192.168.86.248";
        targetUser = "jboyens";
        tags = ["server"];
      };
  };
}
