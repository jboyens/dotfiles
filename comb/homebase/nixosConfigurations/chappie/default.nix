{
  inputs,
  cell,
}: let
  inherit (cell) nixosSuites homeSuites hardwareProfiles;

  bee = {
    system = "x86_64-linux";
    inherit (inputs.cells.common) pkgs;
    home = inputs.home-manager;
  };
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "23.11";

  hostName = "chappie";
in {
  inherit bee time system;
  networking = {inherit hostName;};

  imports =
    [
      hardwareProfiles."${hostName}"
    ]
    ++ nixosSuites.default;

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
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = ["noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/nixstore";
    fsType = "btrfs";
    options = ["noatime"];
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/63ce633c-e5f2-4456-897a-5178d8fec6aa";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  boot.initrd.luks.devices."nixstore" = {
    device = "/dev/pool/cryptnixstore";
    preLVM = false;
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
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
}
