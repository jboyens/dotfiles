{
  inputs,
  lib,
  pkgs,
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
      inputs.home-manager.nixosModules.default
      inputs.stylix.nixosModules.stylix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      defaults
      common-cpu-amd
      common-cpu-amd-pstate
      common-cpu-amd-zenpower
      common-pc-ssd
      common-gpu-amd
    ]);

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "24.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
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
      127.0.0.1	    api.local.flexe.com docker
      172.19.0.3	    hydra.localhost hydra-admin.localhost api.local.flexe.com
      192.168.1.240	argocd.fooninja.org
      192.168.1.240	apps.fooninja.org
    '';
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
        netbootxyz.enable = true;
      };
    };

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb-storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [];
    };

    blacklistedKernelModules = [];
    extraModulePackages = [];
    kernelModules = ["kvm-amd"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];
    extraModprobeConfig = ''
    '';
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

  environment.systemPackages = [kernel.perf];

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
  };

  hardware = {
    # bluetooth
    bluetooth = {
      enable = true;
      settings = {
        General.Enable = "Source,Sink,Media,Socket";
      };
    };
    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa_drivers
        vaapiVdpau
      ];
    };
  };

  # bishop is a beast with 32 listed cores
  nix.settings.max-jobs = lib.mkDefault 32;
}
