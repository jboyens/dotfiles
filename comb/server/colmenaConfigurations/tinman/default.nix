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
      # targetHost = "192.168.86.246";
      targetHost = "10.10.10.2";
      targetUser = "jboyens";
      tags = ["server"];
    };
}
