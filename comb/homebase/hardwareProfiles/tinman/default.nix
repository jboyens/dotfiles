{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  # 2023-08-31 -- issues w/ 6.5.0
  kernel = nixpkgs.linuxPackages_latest;
  lib = nixpkgs.lib // builtins;

  defaults = {
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = kernel;
  };
in {
  imports = with inputs.nixos-hardware.nixosModules; [
    defaults
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
    common-gpu-intel
    # common-gpu-nvidia
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
      "aesni_intel"
      "cryptd"
      "thunderbolt"
    ];
    initrd.kernelModules = ["i915" "dm-snapshot"];

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

  #options iwlwifi 11n_disable=8 bt_coex_active=1 power_save=0
  #options iwlmvm power_scheme=1
  # "i915.enable_fbc=1"
  # "i915.enable_guc=3"
  # "i915.modeset=1"

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General.Enable = "Source,Sink,Media,Socket";
    };
  };

  # a (failed -- 2023-08-23) attempt at using the internal camera
  # tried again (failed -- 2023-09-25)
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";
  # hardware.firmware = [nixpkgs.ipu6ep-camera-bin];

  services.thermald.enable = true;

  # nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   open = true;
  #   nvidiaSettings = true;
  #   prime = {
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  # };

  # services.xserver.videoDrivers = ["nvidia"];

  # thunderbolt
  services.hardware.bolt.enable = true;

  # firmware updates
  services.fwupd = {
    enable = true;
    extraRemotes = [
      "lvfs"
      # "dell-esrt"
    ];
  };

  # fingerprint sensor setup
  services.fprintd = {
    enable = true;
  };

  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    swaylock.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  # chappie has 20 listed cores, but a bunch are e-cores, let's save those and
  # utilize the HT cores.
  nix.settings.max-jobs = lib.mkDefault 12;
}
