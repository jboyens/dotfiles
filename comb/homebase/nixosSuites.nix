{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;

  # alias to reduce collisions and typing
  p = nixosProfiles;
in rec {
  base = with p; [core cachix];

  development = with p; [vm.qemu vm.docker];

  server = [];

  laptop = base ++ (with p; [audio desktop keyboard styles p.server.printing]) ++ development ++ server;
}
