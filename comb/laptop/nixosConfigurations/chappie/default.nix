{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs;

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
  bee = {
    system = "x86_64-linux";
    inherit (inputs.cells.common) pkgs;
    home = inputs.home-manager;
  };

  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.05";
  # system.stateVersion = "23.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports = inputs.cells.common.homeSuites.jboyens;
      home.stateVersion = "24.05";
      # home.stateVersion = "23.11";
    };
  };

  networking = {
    hostName = "chappie";

    extraHosts = ''
      192.168.86.1  router.home

      # Hosts
      192.168.86.100	irongiant
      192.168.86.96	wall-e
      192.168.86.34	mediaserver nas backup-host
      192.168.49.2	dev dev.fooninja.org
      127.0.0.1	    api.local.flexe.com docker
      172.19.0.3	    hydra.localhost hydra-admin.localhost api.local.flexe.com
      192.168.1.240	argocd.fooninja.org
      192.168.1.240	apps.fooninja.org
    '';
  };
  imports =
    [
      # work around a jankety stylix issue
      {options.programs = {};}
      cell.hardwareProfiles.chappie
    ]
    ++ cell.nixosSuites.default;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        netbootxyz.enable = true;
        extraEntries = {
          "shell.conf" = ''
            title UEFI-Shell
            efi /efi/edk2-uefi-shell/shell.efi
          '';
          "windows.conf" = ''
            title Windows
            efi /efi/edk2-uefi-shell/shell.efi
            options -nointerrupt -noconsolein -noconsoleout efi/edk2-uefi-shell/windows.nsh
          '';
        };
        extraFiles = {
          "efi/edk2-uefi-shell/shell.efi" = "${pkgs.edk2-uefi-shell}";
          "efi/edk2-uefi-shell/windows.nsh" = pkgs.writeTextFile {
            name = "windows.nsh";
            text = ''
              HD2c:EFI\Boot\BootX64.efi
            '';
          };
        };
      };
    };

    initrd = {
      systemd.enable = true;

      luks = {
        devices = {
          "cryptroot" = {
            device = "/dev/disk/by-uuid/63ce633c-e5f2-4456-897a-5178d8fec6aa";
            allowDiscards = true;
            bypassWorkqueues = true;
          };
          "nixstore" = {
            device = "/dev/pool/cryptnixstore";
            keyFile = "/sysroot/nixstore_keyfile.bin";
            allowDiscards = true;
            bypassWorkqueues = true;
          };
        };
      };
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
}
