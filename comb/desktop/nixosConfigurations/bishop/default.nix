{
  inputs,
  cell,
}: {
  bee = {
    system = "x86_64-linux";
    inherit (inputs.cells.common) pkgs;
    home = inputs.home-manager;
  };

  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports =
        inputs.cells.common.homeSuites.primary
        ++ [
          inputs.cells.common.homeModules.secrets
        ];
      home.stateVersion = "24.11";
    };
  };

  networking = {
    hostName = "bishop";

    extraHosts = ''
      192.168.86.1  router.home

      # Hosts
      192.168.86.100	irongiant
      192.168.86.96	wall-e
      192.168.86.34	mediaserver nas backup-host
      192.168.49.2	dev dev.fooninja.org
      192.168.1.240	argocd.fooninja.org
      192.168.1.240	apps.fooninja.org
    '';
  };

  imports =
    [
      cell.hardwareProfiles.bishop
    ]
    ++ cell.nixosSuites.default
    ++ inputs.cells.common.nixosSuites.default;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        netbootxyz.enable = true;
      };
    };

    initrd = {
      systemd.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p2";
      fsType = "ext4";
      options = ["noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 10240;
    }
  ];
}
