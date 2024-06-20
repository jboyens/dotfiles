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
      targetHost = "tinman.taila7ca.ts.net";
      targetUser = "jboyens";
      tags = ["server"];
    };
}
