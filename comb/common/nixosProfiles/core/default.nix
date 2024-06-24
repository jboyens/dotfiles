{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs;
  inherit (pkgs) writeScriptBin;
in {
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
}
