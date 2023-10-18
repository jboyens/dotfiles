{
  inputs,
  cell,
}:
# inputs.hive.findLoad {
#   inherit inputs cell;
#   block = ./.;
# }
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) writeScriptBin;

  lib = cell.lib // nixpkgs.lib;

  # baseRepo = "sftp://jboyens@192.168.86.34:2223//backup";
  baseRepo = "rest:http://192.168.86.34:8899";

  pruneOpts = [
    "--keep-hourly 24"
    "--keep-daily 7"
    "--keep-weekly 5"
    "--keep-monthly 12"
    "--keep-yearly 75"
  ];

  # Hive or Std or Paisano or something treats nixpkgs as "special"
  # this breaks nixpkgs.outPath so we've got to filter it
  filteredInputs = lib.filterAttrs (n: _: n != "self" && n != "cells" && n != "nixpkgs") inputs;
  nixPathInputs = lib.mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
  registryInputs = lib.mapAttrs (_: v: {flake = v;}) filteredInputs;
in {
  config = {
    security.rtkit.enable = true;
    security.sudo.extraRules = [
      {
        users = ["jboyens"];
        commands = [
          {
            command = "/run/current-system/sw/bin/loadkeys";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    nix.settings = {
      substituters = ["https://cache.nixos.org"];

      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    nix.sshServe.enable = true;
    nix.sshServe.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL915OY2qIMYEk/jHRFE4mNo0lUANs7Qwe+D0pSommD jboyens@fooninja.org"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDECXnI34NJU+L32GB7vwdTv4R9Uv53DElOZ5T/1or7X1VJxEb2+vNjxFQm1WNru1p23Wq8vGKasjIJt20L3B2E+9A2JHuL8MDpXU5Ednk3TgR1ghSdXzqmUTWmEMuqeU7nzYtnFeEyMSpW/FLy8YxO69C3QKsJGlk6+zEMYy17EhcT87K37/Odw326yXqEG2PAyQFQuSUSUIKixjLqYdRyVUTS43PY9kFwny4XqBof+vprkSfpQJi9qbSYPTOlfdadVE4wtb0TBdHRPS9owBk09ouj3okbT4TyEgedG6QrZn5j06nAYZqI4ggAI3sKgvLaec5jwqF+mX0Jo8naV4in jr@irongiant.local"
    ];

    boot = {
      # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
      # on ssd systems, and volatile! Because it's wiped on reboot.
      tmp.useTmpfs = true;

      # Fix a security hole in place for backwards compatibility. See desc in
      # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
      loader.systemd-boot.editor = false;

      kernel.sysctl = {
        # The Magic SysRq key is a key combo that allows users connected to the
        # system console of a Linux kernel to perform some low-level commands.
        # Disable it, since we don't need it, and is a potential security concern.
        "kernel.sysrq" = 0;

        ## TCP hardening
        # Prevent bogus ICMP errors from filling up logs.
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        # Reverse path filtering causes the kernel to do source validation of
        # packets received from all interfaces. This can mitigate IP spoofing.
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        # Do not accept IP source route packets (we're not a router)
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        # Don't send ICMP redirects (again, we're on a router)
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        # Refuse ICMP redirects (MITM mitigations)
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        # Protects against SYN flood attacks
        "net.ipv4.tcp_syncookies" = 1;
        # Incomplete protection again TIME-WAIT assassination
        "net.ipv4.tcp_rfc1337" = 1;

        ## TCP optimization
        # TCP Fast Open is a TCP extension that reduces network latency by packing
        # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
        # both incoming and outgoing connections:
        "net.ipv4.tcp_fastopen" = 3;
        # Bufferbloat mitigations + slight improvement in throughput & latency
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };

      kernelModules = ["tcp_bbr"];
    };

    environment.variables = {
      DOTFILES = "/home/jboyens/.config/dotfiles";
      DOTFILES_BIN = "/home/jboyens/.config/dotfiles/bin";

      ZDOTDIR = "/home/jboyens/.config/zsh";
      ZSH_CACHE = "/home/jboyens/.config/zsh";
      ZGEN_DIR = "/home/jboyens/.local/share/zgenom";

      DOCKER_BUILDKIT = "1";
    };

    environment.extraInit = ''
      export PATH=$DOTFILES_BIN:$PATH
    '';

    environment.systemPackages = with inputs.nixpkgs; [
      bind
      binutils
      bottom
      cacert
      cached-nix-shell
      coreutils
      curl
      dnsutils
      fd
      file
      git
      gnumake
      iputils
      jq
      pciutils
      ripgrep
      unzip
      wget
      whois

      nixfmt
      nixpkgs-fmt
      alejandra

      lm_sensors

      fasd

      xdg-utils

      docker
      docker-compose
      nixpkgs.solo2-cli
      (writeScriptBin "lxc-build-nixos-image" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nixos-generators
        set -xe
        config=$1
        metaimg=`nixos-generate -f lxc-metadata \
          | xargs -r cat \
          | awk '{print $3}'`
        img=`nixos-generate -c $config -f lxc \
          | xargs -r cat \
          | awk '{print $3}'`
        lxc image import --alias nixos $metaimg $img
      '')
      qemu
      virt-manager
    ];

    environment.pathsToLink = ["/share/zsh"];

    fonts.enableDefaultPackages = true;
    fonts.packages = with nixpkgs; [
      (inputs.nixpkgs.iosevka-bin.override {variant = "etoile";})
      (inputs.nixpkgs.iosevka-bin.override {variant = "aile";})
      inputs.cells.homebase.packages.pragmasevka
      inputs.nixpkgs.noto-fonts-emoji

      ubuntu_font_family
      dejavu_fonts
      symbola
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      cascadia-code
      atkinson-hyperlegible
      inconsolata
      curie
      scientifica
      ttf-envy-code-r
      fira
      fira-code
      fira-mono
      iosevka-bin
      (iosevka-bin.override {variant = "sgr-iosevka-term";})
      _3270font
      jetbrains-mono
      hack-font
      ibm-plex
      oxygenfonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    fonts.fontconfig.defaultFonts = {
      serif = ["Iosevka Etoile"];
      sansSerif = ["Iosevka Aile"];
      monospace = ["Pragmasevka"];
      emoji = ["Noto Color Emoji"];
    };
    networking = {
      useDHCP = false;
      wireless.iwd.enable = true;
      useNetworkd = true;
      domain = "fooninja.org";

      firewall.checkReversePath = "loose";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.settings = {
      sandbox = true;

      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel" "nix-ssh"];

      auto-optimise-store = true;
    };

    # HACK
    nix.nixPath =
      nixPathInputs
      ++ [
        "nixpkgs=${inputs.std.inputs.nixpkgs}"
      ];

    nix.registry = registryInputs // {nixpkgs.flake = inputs.std.inputs.nixpkgs;};

    nix.extraOptions = ''
      experimental-features = nix-command flakes
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

    programs.udevil.enable = true;
    programs.ssh.startAgent = true;
    programs.zsh.enable = true;
    programs.dconf.enable = true;

    programs.wireshark.enable = true;
    programs.wireshark.package = nixpkgs.wireshark;
    # Prevent replacing the running kernel w/o reboot
    security.protectKernelImage = true;

    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    services.earlyoom.enable = true;
    services.earlyoom.enableNotifications = true;
    services.earlyoom.enableDebugInfo = false;

    services.atd.enable = true;

    services.nscd.enableNsncd = true;

    services.nfs.idmapd.settings = {
      General = {Domain = "fooninja.org";};
      Translation = {GSS-Methods = "static,nsswitch";};
      Static = {"jboyens@fooninja.org" = "jboyens";};
    };

    services.dbus.packages = [nixpkgs.gcr];

    services.tailscale.enable = true;
    systemd.network.networks = let
      networkConfig = {
        DHCP = "yes";
        Domains = "fooninja.org";
      };
    in {
      "90-wireless" = {
        enable = true;
        name = "wl*";
        inherit networkConfig;
      };

      "70-wired" = {
        enable = true;
        name = "en*";
        networkConfig = {
          inherit (networkConfig) Domains;
          DHCP = "yes";
        };

        dhcpV4Config.RouteMetric = 10;
        ipv6AcceptRAConfig.RouteMetric = 10;
      };
    };

    # services.NetworkManager-wait-online.enable = lib.mkForce false;
    systemd.network.wait-online.enable = lib.mkForce false;
    #
    users.users.jboyens = {
      initialPassword = "nixos";
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "adbusers"
        "atd"
        "audio"
        "docker"
        "input"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "vaultwarden"
        "vboxusers"
        "video"
        "wheel"
        "wireshark"
      ];
      group = "users";
      shell = nixpkgs.zsh;
    };
    fonts.fontDir.enable = true;
    fonts.enableGhostscriptFonts = true;
    # even though this is managed via home-manager, this sets up some pam stuff
    # that is important
    programs.sway = {
      enable = true;

      wrapperFeatures = {
        gtk = true;
        base = true;
      };

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_WEBRENDER=1
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
        export NIXOS_OZONE_WL=1
        export XCURSOR_PATH=${nixpkgs.dracula-icon-theme}/share/icons
        export XCURSOR_THEME=Dracula
        export WLR_DRM_NO_MODIFIERS=1
      '';
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings = {
        screencast = {
          output_name = "DP-4";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${nixpkgs.slurp}/bin/slurp -f %o -or";
        };
      };
      extraPortals = with nixpkgs; [xdg-desktop-portal-gtk];
    };

    programs.thunar = {
      enable = true;
      plugins = with nixpkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "/home/jboyens"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';

    programs.adb.enable = true;

    services.udev.packages = [
      nixpkgs.android-udev-rules
      nixpkgs.solo2-cli
    ];

    # hey... it's kind of a keyboard.
    hardware.keyboard.zsa.enable = true;
    networking.firewall.allowedTCPPorts = [8080];

    hardware.printers = {
      ensureDefaultPrinter = "HLL2350DW";
      ensurePrinters = [
        {
          name = "HLL2350DW";
          deviceUri = "ipp://192.168.86.39";
          model = "everywhere";
          ppdOptions = {
            PageSize = "Letter";
            Duplex = "DuplexNoTumble";
          };
        }
      ];
    };
    services.system-config-printer.enable = true;
    services.printing = {
      enable = true;
    };
    services.restic.backups = {
      Workspace = {
        user = "jboyens";
        paths = ["/home/jboyens/Workspace"];
        repository = "${baseRepo}/Workspace-restic";
        inherit pruneOpts;
        extraBackupArgs = [
          "-e /home/jboyens/Workspace/shyft_api_server/log"
          "-e /home/jboyens/Workspace/shyft_api_server/tmp"
          "-e /home/jboyens/Workspace/warehouser/log"
          "-e /home/jboyens/Workspace/warehouser/tmp"
        ];
        timerConfig = {
          OnCalendar = "hourly";
          RandomizedDelaySec = 900;
        };
        passwordFile = "/home/jboyens/.secrets/backup.secret";
      };
      Mail = {
        user = "jboyens";
        paths = ["/home/jboyens/.mail"];
        repository = "${baseRepo}/Mail-restic";
        inherit pruneOpts;
        timerConfig = {
          OnCalendar = "hourly";
          RandomizedDelaySec = 900;
        };
        passwordFile = "/home/jboyens/.secrets/backup.secret";
      };
      Home = {
        user = "jboyens";
        paths = ["/home/jboyens"];
        repository = "${baseRepo}/home-restic";
        inherit pruneOpts;
        extraBackupArgs = ["--exclude-file /home/jboyens/restic-exclude.txt" "-x"];
        timerConfig = {
          OnCalendar = "hourly";
          RandomizedDelaySec = 900;
        };
        passwordFile = "/home/jboyens/.secrets/backup.secret";
      };
    };

    systemd.services.restic-backups-Home.serviceConfig.CPUQuota = "200%";
    systemd.services.restic-backups-Home.serviceConfig.IOWeight = "1";
    systemd.services.restic-backups-Mail.serviceConfig.CPUQuota = "200%";
    systemd.services.restic-backups-Mail.serviceConfig.IOWeight = "1";
    systemd.services.restic-backups-Workspace.serviceConfig.CPUQuota = "200%";
    systemd.services.restic-backups-Workspace.serviceConfig.IOWeight = "1";

    users.users.jboyens.openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDECXnI34NJU+L32GB7vwdTv4R9Uv53DElOZ5T/1or7X1VJxEb2+vNjxFQm1WNru1p23Wq8vGKasjIJt20L3B2E+9A2JHuL8MDpXU5Ednk3TgR1ghSdXzqmUTWmEMuqeU7nzYtnFeEyMSpW/FLy8YxO69C3QKsJGlk6+zEMYy17EhcT87K37/Odw326yXqEG2PAyQFQuSUSUIKixjLqYdRyVUTS43PY9kFwny4XqBof+vprkSfpQJi9qbSYPTOlfdadVE4wtb0TBdHRPS9owBk09ouj3okbT4TyEgedG6QrZn5j06nAYZqI4ggAI3sKgvLaec5jwqF+mX0Jo8naV4in jr@irongiant.local"];
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "jboyens";
      configDir = "/home/jboyens/.config/syncthing";
      dataDir = "/home/jboyens/.local/share/syncthing";
    };
    # tlp = {
    #   enable = true;
    #   settings = {
    #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #   };
    # };

    # I know the module says tlp, but I'm trying this out
    services.auto-cpufreq = {
      enable = true;
    };

    virtualisation = {
      # Creating an image:
      #   qemu-img create -f qcow2 disk.img
      # Creating a snapshot (don't tamper with disk.img):
      #   qemu-img create -f qcow2 -b disk.img snapshot.img

      libvirtd.enable = true;

      docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };
    };

    # programs.hyprland = {
    #   enable = true;
    #   package = inputs.hyprland.packages.hyprland;
    # };

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
  };
}
