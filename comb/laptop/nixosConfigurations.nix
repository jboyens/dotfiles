{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) nixosSuites;
  inherit (inputs.cells.common) homeSuites;
  inherit (cell) hardwareProfiles;

  bee = {
    system = "x86_64-linux";
    inherit (inputs.cells.common) pkgs;
    home = inputs.home-manager;
  };
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "23.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports = homeSuites.jboyens;
      home.stateVersion = "23.11";
    };
  };

  common-boot = {
    initrd.systemd.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      # systemd-boot.netbootxyz.enable = true;
    };
  };

  nas-fileSystems = let
    options = [
      "nfsvers=4.1"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  in {
    "/mnt/nas/homes" = {
      device = "192.168.86.34:/volume1/homes";
      fsType = "nfs";
      inherit options;
    };
    "/mnt/nas/backup" = {
      device = "192.168.86.34:/volume1/backup";
      fsType = "nfs";
      inherit options;
    };
    "/mnt/nas/music" = {
      device = "192.168.86.34:/volume1/music";
      fsType = "nfs";
      inherit options;
    };
    "/mnt/nas/movies" = {
      device = "192.168.86.34:/volume1/movies";
      fsType = "nfs";
      inherit options;
    };
  };
in {
  chappie = let
    hostName = "chappie";
  in {
    inherit bee time system home-manager;
    networking = {inherit hostName;};
    imports =
      [
        hardwareProfiles."${hostName}"
      ]
      ++ nixosSuites.laptop;

    boot =
      common-boot
      // {
        initrd.luks.devices."cryptroot" = {
          device = "/dev/disk/by-uuid/63ce633c-e5f2-4456-897a-5178d8fec6aa";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
        initrd.luks.devices."nixstore" = {
          device = "/dev/pool/cryptnixstore";
          keyFile = "/sysroot/nixstore_keyfile.bin";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };

    fileSystems =
      {
        "/" = {
          device = "/dev/mapper/cryptroot";
          fsType = "btrfs";
          options = ["noatime"];
        };
        "/nix" = {
          device = "/dev/mapper/nixstore";
          fsType = "btrfs";
          options = ["noatime"];
        };
        "/boot" = {
          device = "/dev/disk/by-label/BOOT";
          fsType = "vfat";
        };
      }
      // nas-fileSystems;

    swapDevices = [
      {
        device = "/swapfile";
        size = 10240;
      }
    ];
  };

  kitt = let
    hostName = "kitt";
  in {
    inherit bee time system home-manager;
    networking = {inherit hostName;};
    imports =
      [
        hardwareProfiles."${hostName}"
      ]
      ++ nixosSuites.laptop;
    boot =
      common-boot
      // {
        initrd.luks.devices."cryptroot" = {
          device = "/dev/disk/by-uuid/6e6f01d5-826a-40e9-8fa7-cfcc4616dd92";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };

    fileSystems =
      {
        "/" = {
          # device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
          options = ["noatime"];
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/C04A-6D05";
          fsType = "vfat";
        };
      }
      // nas-fileSystems;

    swapDevices = [
      {
        device = "/swapfile";
        size = 10240;
      }
    ];
  };
}
