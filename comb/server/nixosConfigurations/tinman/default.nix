{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) nixosSuites;
  inherit (inputs.cells.common) homeSuites;
  inherit (cell) hardwareProfiles;
  inherit (cell) nixosModules;

  serverSuites = cell.nixosSuites;

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
      nixosModules.blocky
    ]
    ++ nixosSuites.default
    ++ serverSuites.default;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jboyens = {
      imports = homeSuites.jboyens-basic;

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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b9b37dbb-7c7e-48b6-b15f-a60ee099fde5";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C880-9F28";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/80d0e1f2-6110-41f1-8d9f-7c49cc1e4644";
    }
  ];
}
