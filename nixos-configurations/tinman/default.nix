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
      # inputs.lix-module.nixosModules.default
      inputs.home-manager.nixosModules.default
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      defaults
      common-cpu-intel
      common-pc-laptop
      common-pc-laptop-ssd
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
    hostName = "tinman";
  };

  security.sudo.wheelNeedsPassword = false;

  boot = {
    initrd.systemd.enable = true;
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" "aesni_intel" "cryptd" "thunderbolt"];
    initrd.kernelModules = ["i915" "dm-snapshot"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
    };

    blacklistedKernelModules = ["iTCO_wdt" "nouveau" "nvidia"];
    extraModulePackages = with kernel; [acpi_call];
    kernelModules = ["kvm-intel"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      "i915.mitigations=off"
      "mem_sleep_default=deep"
      "nmi_watchdog=0"
    ];
    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
    '';
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General.Enable = "Source,Sink,Media,Socket";
    };
  };

  services = {
    thermald.enable = true;

    # thunderbolt
    hardware.bolt.enable = true;

    # firmware updates
    fwupd = {
      enable = true;
      extraRemotes = [
        "lvfs"
        # "dell-esrt"
      ];
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.settings.max-jobs = lib.mkDefault 4;

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
