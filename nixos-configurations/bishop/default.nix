{
  inputs,
  pkgs,
  ezModules,
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
      inputs.lix-module.nixosModules.default
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
    extraModulePackages = with kernel; [v4l2loopback];
    kernelModules = ["kvm-amd"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"

      # λ sudo filefrag -v /swapfile| awk '$1=="0:" { print substr($4, 1, length($4)-2) }'
      "resume_offset=431001600"
    ];

    kernelPatches = [
      # {
      #   name = "amd-vcache-3d-vcache";
      #   patch = [
      #     ./0001-platform-x86-amd-amd_3d_vcache-Add-AMD-3D-V-Cache-op.patch
      #     ./0002-platform-x86-amd-amd_3d_vcache-Add-sysfs-ABI-documen.patch
      #   ];
      #   extraConfig = ''
      #     AMD_3D_VCACHE y
      #   '';
      # }
      # {
      #   name = "amd-hfi";
      #   patch = null;
      #   extraConfig = ''
      #     AMD_HFI y
      #   '';
      # }
    ];

    extraModprobeConfig = ''
      options iwlmvm power_scheme=1
      options iwlwifi 11n_disable=8
      options cfg80211 ieee80211_regdom=US
    '';

    # λ findmnt -no UUID -T /swapfile
    resumeDevice = "/dev/disk/by-uuid/703145ec-80a3-4d0f-a858-419dcd773248";
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

  environment = {
    systemPackages = [kernel.perf];
    variables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };
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

    openrazer.enable = true;
    openrazer.users = ["jboyens"];

    amdgpu = {
      amdvlk.enable = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        vaapiVdpau
      ];
    };
  };

  # bishop is a beast with 32 listed cores
  nix.settings = {
    cores = lib.mkDefault 32;
    max-jobs = lib.mkDefault 4;
  };
}
