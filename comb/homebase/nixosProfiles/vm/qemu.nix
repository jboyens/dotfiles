{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [
    qemu
    virt-manager
  ];

  virtualisation.libvirtd.enable = true;

  programs.dconf.enable = true;

  users.users.jboyens.extraGroups = ["libvirtd"];
}
# Creating an image:
#   qemu-img create -f qcow2 disk.img
# Creating a snapshot (don't tamper with disk.img):
#   qemu-img create -f qcow2 -b disk.img snapshot.img

