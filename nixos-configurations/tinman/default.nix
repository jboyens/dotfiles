{
  inputs,
  pkgs,
  ezModules,
  ...
}: let
  inherit (pkgs) lib;
  kernel = pkgs.linuxPackages_latest;

  defaults = {
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = kernel;
  };
in {
  imports =
    [
      inputs.home-manager.nixosModules.default
      ezModules.vaultwarden
      ezModules.blocky
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
  system.stateVersion = "25.11";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  networking = {
    hostName = "tinman";
    firewall.allowedTCPPorts = [5055 9000];
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

  hardware.bluetooth = {
    enable = true;
    settings = {
      General.Enable = "Source,Sink,Media,Socket";
    };
  };

  services = {
    thermald.enable = true;

    hardware.bolt.enable = true;

    fwupd = {
      enable = true;
      extraRemotes = ["lvfs"];
    };

    promtail = {
      enable = true;
      configuration = {
        clients = [
          {url = "http://192.168.86.100:3100/loki/api/v1/push";}
        ];

        scrape_configs = [
          {
            job_name = "system";
            static_configs = [
              {
                targets = ["localhost"];
                labels = {
                  job = "varlogs";
                  host = "192.168.86.246";
                  __path__ = "/var/log/*.log";
                };
              }
            ];
          }
          {
            job_name = "journal";
            journal = {
              labels = {
                job = "systemd-journal";
                host = "192.168.86.246";
              };
              max_age = "12h";
            };
            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
            ];
          }
        ];

        server = {
          http_listen_port = 9000;
          grpc_listen_port = 0;
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    overseerr = {
      image = "sctx/overseerr";
      environment = {
        TZ = "America/Los_Angeles";
        PUID = "1000";
        PGID = "1000";
        LOG_LEVEL = "debug";
      };
      volumes = [
        "/home/jboyens/config/overseerr:/app/config"
      ];
      ports = [
        "5055:5055/tcp"
      ];
    };

    watchtower = {
      image = "ghcr.io/containrrr/watchtower";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      environment = {
        WATCHTOWER_CLEANUP = "true";
        WATCHTOWER_POLL_INTERVAL = "86400";
      };
      extraOptions = [
        "--privileged"
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
