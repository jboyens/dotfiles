{
  inputs,
  pkgs,
  ezModules,
  config,
  ...
}: let
  kernel = pkgs.linuxPackages_latest;
  lib = pkgs.lib // builtins;

  defaults = {
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = kernel;
  };
in {
  imports =
    [
      # inputs.lix-module.nixosModules.default
      inputs.home-manager.nixosModules.default
      inputs.stylix.nixosModules.stylix
      ezModules.android
      ezModules.backup
      ezModules.fonts
      ezModules.graphical
      ezModules.hardware
      ezModules.pipewire
      ezModules.printing
      ezModules.styling
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      defaults
      common-cpu-intel
      common-pc-laptop
      common-pc-ssd
      common-gpu-intel
    ]);

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  networking = {
    hostName = "mechagodzilla";
  };

  # imports =
  # [
  #   cell.hardwareProfiles.bishop
  # ]
  # ++ cell.nixosSuites.default
  # ++ inputs.cells.common.nixosSuites.default;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        netbootxyz.enable = false;
      };
    };

    initrd = {
      systemd.enable = true;
      compressor = "zstd";
      compressorArgs = [
        "--ultra"
        "-22"
      ];
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
        "usbhid"
      ];
      kernelModules = [];
    };

    # blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [];
    kernelModules = ["kvm-intel"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];

    kernelPatches = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/65c90037-d318-4276-afb4-85dcc2d06d62";
      fsType = "ext4";
      options = ["noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6A53-1546";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 10240;
    }
  ];

  environment.systemPackages = [kernel.perf];
  environment.variables = {
    # VDPAU_DRIVER = lib.mkOverride 990 "nvidia";
  };

  services = {
    thermald.enable = false;

    # firmware updates
    fwupd = {
      enable = true;
      extraRemotes = [
        "lvfs"
        "lvfs-testing"
      ];
    };

    # xserver.videoDrivers = [ "nvidia" ];
  };

  hardware = {
    # bluetooth
    bluetooth = {
      enable = true;
      settings = {
        General.Enable = "Source,Sink,Media,Socket";
      };
    };
    cpu.intel.updateMicrocode = true;

    nvidia = {
      modesetting.enable = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = false;

      prime = {
        sync.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    openrazer.enable = false;
    openrazer.users = ["jboyens"];

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        vaapiVdpau
      ];
    };
  };

  # mechagodzilla is a mobile beast with 32 listed cores
  nix.settings = {
    cores = lib.mkDefault 32;
    max-jobs = lib.mkDefault 4;
  };
}
