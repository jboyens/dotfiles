{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_usb_sdmmc" "aes_x86_64" "aesni_intel" "cryptd" "i915" ];
    initrd.kernelModules = [];
    extraModulePackages = [
      (pkgs.linuxPackages_latest.v4l2loopback.overrideAttrs (oa: rec {
        name = "v4l2loopback-${version}-${pkgs.linuxPackages_latest.kernel.version}";
        version = "0.12.5";
        src = pkgs.fetchFromGitHub {
          owner = "umlaeute";
          repo = "v4l2loopback";
          rev = "v${version}";
          sha256 = "1qi4l6yam8nrlmc3zwkrz9vph0xsj1cgmkqci4652mbpbzigg7vn";
        };
      }))
    ];
    kernelModules = [
      "kvm-intel"
      "v4l2loopback"
    ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      "mem_sleep_default=deep"
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
      options iwlwifi 11n_disable=8 bt_coex_active=1 power_save=0
      options iwlmvm power_scheme=1
    '';
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiIntel vaapiVdpau libvdpau-va-gl intel-media-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva vaapiIntel ];
    };
    pulseaudio.support32Bit = true;
    steam-hardware.enable = true;
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;

      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt pkgs.pulseeffects ];
    };
  };
  services.hardware.bolt.enable = true;

  # CPU
  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = true;

  # Storage
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

  services.udev.extraRules = ''
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  '';
}
