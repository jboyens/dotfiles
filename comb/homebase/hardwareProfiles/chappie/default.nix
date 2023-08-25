{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

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
    common-gpu-nvidia
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "rtsx_usb_sdmmc"
      "aesni_intel"
      "cryptd"
    ];
    initrd.kernelModules = ["i915"];

    blacklistedKernelModules = ["iTCO_wdt" "nouveau"];
    extraModulePackages = with kernel; [v4l2loopback acpi_call];
    kernelModules = ["kvm-intel" "v4l2loopback" "akvcam"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      "i915.mitigations=off"
      "i915.enable_fbc=1"
      "i915.enable_guc=3"
      "i915.modeset=1"
      "mem_sleep_default=deep"
      "nmi_watchdog=0"
    ];
    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
    '';
  };

  #options iwlwifi 11n_disable=8 bt_coex_active=1 power_save=0
  #options iwlmvm power_scheme=1

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General.Enable = "Source,Sink,Media,Socket";
    };
  };

  # a (failed -- 2023-08-23) attempt at using the internal camera
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";
  hardware.firmware = [nixpkgs.ipu6ep-camera-bin];

  services.thermald.enable = true;

  # nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # thunderbolt
  services.hardware.bolt.enable = true;

  # firmware updates
  services.fwupd = {
    enable = true;
    extraRemotes = ["lvfs" "dell-esrt"];
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
