{
  inputs,
  cell,
}: rec {
  inherit (inputs.cells) common laptop;

  default = [
    common.nixosProfiles.core
    common.nixosProfiles.networking
    common.nixosProfiles.nix
    common.nixosProfiles.security
    common.nixosProfiles.users
    common.nixosProfiles.virtualisation
  ];
}
