{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  udevil.enable = true;
  ssh.startAgent = true;
  zsh.enable = true;
  dconf.enable = true;

  wireshark.enable = true;
  wireshark.package = nixpkgs.wireshark;
}
