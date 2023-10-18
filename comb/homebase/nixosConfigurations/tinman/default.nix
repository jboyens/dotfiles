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

  hostName = "tinman";
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

  boot.initrd.systemd.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 10;
    systemd-boot.enable = true;
    # systemd-boot.netbootxyz.enable = true;
  };
  # boot.kernelParams = ["delayacct"];

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
    keyFile = "/sysroot/nixstore_keyfile.bin";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 10240;
    }
  ];
}
