{
  inputs,
  cell,
}: rec {
  inherit (inputs.cells) common;

  default =
    [
      cell.nixosProfiles.core
      cell.nixosProfiles.backup
      cell.nixosProfiles.fonts
      cell.nixosProfiles.pipewire
    ]
    ++ common.nixosSuites.default;
}
