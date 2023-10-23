{
  inputs,
  cell,
}: let
  common = inputs.common;
in {
  inherit (common) bee;

  imports = [cell.nixosConfigurations.tinman];

  deployment =
    common.deployment
    // {
      targetHost = "192.168.86.248";
      targetUser = "jboyens";
      tags = ["server"];
    };
}
