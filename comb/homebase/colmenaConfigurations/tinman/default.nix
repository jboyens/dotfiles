{
  inputs,
  cell,
}: let
  inherit (inputs) common;
in {
  imports = [cell.nixosConfigurations.tinman];
  inherit (common) bee;

  deployment =
    common.deployment
    // {
      targetHost = "192.168.86.246";
      targetUser = "jboyens";
      tags = ["server"];
    };
}
