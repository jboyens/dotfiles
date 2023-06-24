{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;

  # alias to reduce collisions and typing
  p = nixosProfiles;
in rec {
  base = with p; [core cachix];

  development = with p; [vm.qemu];

  server = [p.server.prometheus];

  laptop = base ++ (with p; [audio keyboard styles]) ++ development ++ server;
}
