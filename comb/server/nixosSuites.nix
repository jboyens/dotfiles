{
  inputs,
  cell,
}: rec {
  inherit (inputs.cells) common;

  default = [
    cell.nixosProfiles.vaultwarden
    cell.nixosProfiles.containers
    cell.nixosProfiles.dns
  ];
}
