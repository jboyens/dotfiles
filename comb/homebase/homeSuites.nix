{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in {
  jboyens = [
    homeProfiles.everything
    homeProfiles.swaywm
    homeProfiles.firefox
  ];
}
