{
  inputs,
  cell,
}: let
  inherit (inputs) common;
in {
  inherit (common) bee;

  imports = [cell.nixosConfigurations.tinman];

  deployment =
    common.deployment
    // {
      targetHost = "192.168.86.244";
      targetUser = "jboyens";
      tags = ["server"];
    };
}
