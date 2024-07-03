{
  pkgs,
  lib,
  config,
  ...
}: {
  programs = {
    nix-ld.enable = true;
    ssh = {
      startAgent = true;
      enableAskPassword = true;
      askPassword = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
    };

    zsh.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
      flake = "/home/jboyens/.config/dotfiles";
    };
  };

  # services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # networking.networkmanager.enable = false;

  services = {
    earlyoom = {
      enable = true;
      enableNotifications = true;
      enableDebugInfo = false;
    };

    # to receive notifications from earlyoom
    systembus-notify.enable = true;

    openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
  };

  environment = {
    variables = {
      DOTFILES = "/home/jboyens/.config/dotfiles";
      DOTFILES_BIN = "/home/jboyens/.config/dotfiles/bin";

      ZDOTDIR = "/home/jboyens/.config/zsh";
      ZSH_CACHE = "/home/jboyens/.config/zsh";
      ZGEN_DIR = "/home/jboyens/.local/share/zgenom";

      DOCKER_BUILDKIT = "1";
    };

    extraInit = ''
      export PATH=$DOTFILES_BIN:$PATH
    '';

    systemPackages = with pkgs; [
      bind
      binutils
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

      nixfmt-rfc-style
      nixpkgs-fmt
      alejandra

      lm_sensors

      xdg-utils

      docker
      docker-compose

      pkgs.solo2-cli

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

    pathsToLink = ["/share/zsh"];
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        echo "--- diff to current-system"
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
        echo "---"
      fi
    '';
  };
  hardware.printers = {
    ensureDefaultPrinter = "HLL2350DW";
    ensurePrinters = [
      {
        name = "HLL2350DW";
        deviceUri = "ipp://192.168.86.78";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
  };

  hardware.keyboard.zsa.enable = true;

  programs = {
    adb.enable = true;

    hyprland.enable = true;
    hyprlock.enable = true;

    # even though this is managed via home-manager, this sets up some pam stuff
    # that is important
    sway = {
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
        export WLR_DRM_NO_MODIFIERS=1
      '';
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };

    udevil.enable = true;
    dconf.enable = true;

    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  services = {
    syncthing = {
      enable = false;
      openDefaultPorts = false;
      user = "jboyens";
      configDir = "/home/jboyens/.config/syncthing";
      dataDir = "/home/jboyens/.local/share/syncthing";

      settings = {
        devices = {
          mediaserver.id = "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
          chappie.id = "Z6KVBYP-VAKL7WV-GQECKAS-FU23XXB-Q5G2RR3-3JQHCHY-BLGK4UM-B3OETA2";
          pixelfold.id = "DDMWL5O-5YLOW2M-O4LBJI7-MS477DQ-VTKMDLU-WNKAWZB-MPJNYNA-2FEIWAK";
          irongiant.id = "FEEF2M2-B3JYJJX-IHFFP5A-2ZTIGFD-YISKNNB-5G3RML6-ASOG6DB-HSXYKQR";
          bishop.id = "K4XXCS7-TSIQEOC-K76MUR6-SB3P2CJ-WD56IKR-OTS3XZG-VUCHN4B-YMO7DQ5";
        };
      };
    };

    hypridle.enable = lib.mkIf config.programs.hyprland.enable true;

    # command scheduler
    # atd.enable = true;

    # GNOME crypto services?
    dbus.packages = [pkgs.gcr];

    # Virtual filesystem support
    gvfs.enable = true;

    # Printing
    printing = {enable = true;};
    system-config-printer.enable = true;

    # D-Bus thumbnailer
    # tumbler.enable = true;

    udev = {
      packages = [
        pkgs.android-udev-rules
        pkgs.solo2-cli
        pkgs.qmk-udev-rules
      ];

      # ydotool + Pixel Fold + DOIO support
      extraRules = ''
        KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"

        ATTR{idProduct}=="4e11", GOTO="adb", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n", SYMLINK+="android_adb"

        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="d010", MODE="0660", GROUP="input", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
  };

  system.userActivationScripts.cleanupHome = ''
    pushd "/home/jboyens"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];

    wlr = {
      enable = lib.mkForce false;
      settings = {
        screencast = {
          output_name = "DP-4";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
