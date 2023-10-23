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
  chappie = {
    imports = [cell.nixosConfigurations.chappie];
    inherit (common) bee;

    deployment = common.deployment // {tags = ["laptops"];};
  };
}
