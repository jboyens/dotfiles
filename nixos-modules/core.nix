{
  pkgs,
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

      nixfmt
      nixpkgs-fmt
      alejandra

      lm_sensors

      xdg-utils
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

  programs = {
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

    # security.pam.services.<name>.enableGnomeKeyring
    gnome = {
      gnome-keyring.enable = true;
      gnome-settings-daemon.enable = true;
      gcr-ssh-agent.enable = false;
    };
  };

  system.userActivationScripts.cleanupHome = ''
    pushd "/home/jboyens"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';
}
