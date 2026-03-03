{
  inputs,
  cell,
}:
let
  inherit (inputs.cells.common) pkgs;

  kernel = pkgs.linuxPackages_latest;
  lib = pkgs.lib // builtins;

  defaults = {
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = kernel;
  };
in
{
  imports = with inputs.nixos-hardware.nixosModules; [
    defaults
    common-cpu-amd
    common-cpu-amd-pstate
    common-cpu-amd-zenpower
    common-pc-ssd
    common-gpu-amd
  ];

  environment.systemPackages = [ kernel.perf ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb-storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];

    blacklistedKernelModules = [ ];
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" ];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];
    extraModprobeConfig = "";
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
    opengl = {
      enable = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        mesa_drivers
        libva-vdpau-driver
      ];
    };
  };

  # bishop is a beast with 32 listed cores
  nix.settings.max-jobs = lib.mkDefault 32;
}
