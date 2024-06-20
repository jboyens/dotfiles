{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs;

  # nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;

  # 2023-08-31 -- issues w/ 6.5.0
  # 2023-10-23 -- issues w/ 6.6.0-rc7 -- fail to start decryption
  # kernel = nixpkgs-unstable.linuxPackages_latest;
  kernel = pkgs.linuxPackages_latest;
  lib = pkgs.lib // builtins;

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
    # common-gpu-intel
    # common-gpu-nvidia
  ];

  environment.systemPackages = [kernel.perf];

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
    initrd.kernelModules = ["dm-snapshot"];

    blacklistedKernelModules = [
      "iTCO_wdt"
      "nouveau"
    ];
    extraModulePackages = with kernel; [acpi_call]; # v4l2loopback];
    kernelModules = ["kvm-intel"]; # "v4l2loopback"];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      "i915.mitigations=off"
      "i915.enable_guc=2"
      "mem_sleep_default=deep"
      "nmi_watchdog=0"
    ];
    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
      options iwlmvm power_scheme=1
    '';
    # options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
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
        "lvfs-testing"
      ];
    };

    # fingerprint sensor setup
    fprintd = {
      enable = true;
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

    # a (failed -- 2023-08-23) attempt at using the internal camera
    # tried again (failed -- 2023-09-25)
    #ipu6.enable = true;
    #ipu6.platform = "ipu6ep";
    #firmware = [
    #  inputs.ipu6-nix.packages.ipu6-camera-bins
    #];

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        mesa_drivers
        intel-ocl
        vaapiIntel
        vaapiVdpau
        intel-media-driver
        libvdpau-va-gl
        intel-compute-runtime
      ];
    };
  };

  # specialisation = {
  #   nvidia.configuration = {
  services.xserver.videoDrivers = ["nvidia"];
  # system.nixos.tags = ["nvidia"];

  environment.variables = {
    VDPAU_DRIVER = lib.mkOverride 990 "nvidia";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # };

  #   kde.configuration = {
  #     services.xserver.enable = true;
  #     services.xserver.desktopManager.plasma6.enable = true;
  #     services.xserver.displayManager.sddm.enable = true;
  #     services.xserver.autorun = false;
  #   };

  #   gnome.configuration = {
  #     services.xserver.enable = true;
  #     services.xserver.desktopManager.gnome.enable = true;
  #     services.xserver.displayManager.gdm.enable = true;
  #     services.xserver.autorun = false;
  #     hardware.pulseaudio.enable = false;
  #   };
  # };

  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    swaylock.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    KillUserProceses=true
  '';

  # chappie has 20 listed cores, but a bunch are e-cores, let's save those and
  # utilize the HT cores.
  nix.settings.max-jobs = lib.mkDefault 12;
}
