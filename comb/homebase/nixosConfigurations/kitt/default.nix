{
  inputs,
  cell,
}: let
  inherit (cell) nixosSuites homeSuites hardwareProfiles;

  bee = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "23.11";

  hostName = "kitt";
in {
  inherit bee time system;
  networking = {inherit hostName;};

  imports =
    [
      hardwareProfiles."${hostName}"
    ]
    ++ [nixosSuites];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports = homeSuites.jboyens;

      home.stateVersion = "23.11";
    };
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 10;
    systemd-boot.enable = true;
  };

  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = ["noatime"];
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/6e6f01d5-826a-40e9-8fa7-cfcc4616dd92";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C04A-6D05";
    fsType = "vfat";
  };

  fileSystems."/mnt/nas/homes" = {
    device = "192.168.86.34:/volume1/homes";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/backup" = {
    device = "192.168.86.34:/volume1/backup";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/music" = {
    device = "192.168.86.34:/volume1/music";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nas/movies" = {
    device = "192.168.86.34:/volume1/movies";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 10240;
    }
  ];

  # system.stateVersion = "23.11";
}
