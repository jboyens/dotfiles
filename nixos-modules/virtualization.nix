{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx

    qemu

    virt-manager

    (writeScriptBin "lxc-build-nixos-image" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nixos-generators
      set -xe
      config=$1
      metaimg=`nixos-generate -f lxc-metadata \
        | xargs -r cat \
        | awk '{print $3}'`
      img=`nixos-generate -c $config -f lxc \
        | xargs -r cat \
        | awk '{print $3}'`
      lxc image import --alias nixos $metaimg $img
    '')
  ];

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
      # enableNvidia = config.hardware.nvidia.modesetting.enable;
      autoPrune.enable = true;
      listenOptions = [
        "/run/docker.sock"
        "127.0.0.1:2376"
        "[::1]:2376"
      ];
    };
  };
}
