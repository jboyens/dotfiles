{
  inputs,
  cell,
}: let
  lib = builtins // inputs.nixpkgs.lib // cell.lib;
in rec {
  default = [
    cell.nixosProfiles.core
    cell.nixosProfiles.networking
    cell.nixosProfiles.nix
    cell.nixosProfiles.security
    cell.nixosProfiles.users
    cell.nixosProfiles.virtualisation
  ];

  laptop =
    [
      cell.nixosProfiles.core-laptop
      cell.nixosProfiles.backup
      cell.nixosProfiles.fonts
      cell.nixosProfiles.pipewire
      cell.nixosProfiles.tailscale
    ]
    ++ default;

  server =
    [
    ]
    ++ default;
}
