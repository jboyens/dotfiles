{
  inputs,
  cell,
}: {
  virtualisation = {
    # Creating an image:
    #   qemu-img create -f qcow2 disk.img
    # Creating a snapshot (don't tamper with disk.img):
    #   qemu-img create -f qcow2 -b disk.img snapshot.img

    libvirtd.enable = true;

    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
  };
}
