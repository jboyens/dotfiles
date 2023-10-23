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

  hostName = "irongiant";
in {
  inherit bee system time;

  imports =
    [
      hardwareProfiles."${hostName}"
    ]
    ++ nixosSuites.server;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports = homeSuites.jboyens;

      home.stateVersion = "23.11";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  boot.initrd.systemd.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 10;
    systemd-boot.enable = true;
    # systemd-boot.netbootxyz.enable = true;
  };
  # boot.kernelParams = ["delayacct"];

  # Storage
  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/074A-FDB3";
    fsType = "vfat";
  };

  fileSystems."/mnt/nas" = {
    device = "192.168.86.34:/volume1/homes";
    fsType = "nfs";
    options = ["nfsvers=4.1"];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 10240;
    }
  ];
}
