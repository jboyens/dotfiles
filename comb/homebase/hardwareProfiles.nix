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
  kitt = {
    imports = with inputs.nixos-hardware.nixosModules; [
      defaults
      common-cpu-intel
      common-pc-laptop
      common-pc-laptop-ssd
    ];

    boot = {
      initrd = {
        availableKernelModules = [
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
        kernelModules = ["i915"];
      };
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
        options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
        options iwlwifi 11n_disable=8 bt_coex_active=1 power_save=0
        options iwlmvm power_scheme=1
        options nfs nfs4_disable_idmapping=0
      '';
    };

    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General.Enable = "Source,Sink,Media,Socket";
        };
      };
      opengl = {
        enable = true;
        driSupport = true;
      };
    };

    services.hardware.bolt.enable = true;

    services.fwupd = {
      enable = true;
      extraRemotes = ["lvfs" "dell-esrt"];
    };

    nix.settings.max-jobs = lib.mkDefault 12;
  };
}
