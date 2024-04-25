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

    # podman = {
    #   enable = true;
    #   enableNvidia = config.hardware.nvidia.modesetting.enable;
    #   autoPrune.enable = true;
    # };

    docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = config.hardware.nvidia.modesetting.enable;
      autoPrune.enable = true;
      listenOptions = ["/run/docker.sock" "127.0.0.1:2376" "[::1]:2376"];
    };
  };
}
