{
  inputs,
  cell,
}: let
  inherit (inputs) common;
in {
  inherit (common) bee;

  imports = [cell.nixosConfigurations.irongiant];

  deployment =
    common.deployment
    // {
      targetHost = "192.168.86.100";
      targetUser = "jboyens";
      tags = [""];
    };
}
