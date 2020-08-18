# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mitigations=off" "i915.enable_guc=2" ];
  boot.blacklistedKernelModules = [ ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "rtsx_usb_sdmmc"
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
    "i915"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    (pkgs.linuxPackages_latest.v4l2loopback.overrideAttrs (oa: rec {
      name =
        "v4l2loopback-${version}-${pkgs.linuxPackages_latest.kernel.version}";
      version = "0.12.5";
      src = pkgs.fetchFromGitHub {
        owner = "umlaeute";
        repo = "v4l2loopback";
        rev = "v${version}";
        sha256 = "1qi4l6yam8nrlmc3zwkrz9vph0xsj1cgmkqci4652mbpbzigg7vn";
      };
    }))
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
  '';

  hardware.nvidia = {
    modesetting.enable = true;
    optimus_prime = {
      enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  '';

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;

    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt pkgs.pulseeffects ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/14c3182f-f307-466a-8de3-b750e11ed995";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot.initrd.luks.devices."cryptroot"= {
    device = "/dev/disk/by-uuid/6e6f01d5-826a-40e9-8fa7-cfcc4616dd92";
    allowDiscards = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/161F-64F3";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 10240;
  }];

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
