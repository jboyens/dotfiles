{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) writeScriptBin;

  lib = cell.lib // nixpkgs.lib;
in {
  programs.ssh.startAgent = true;
  programs.zsh.enable = true;

  services.nscd.enableNsncd = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;
  services.earlyoom.enableDebugInfo = false;

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
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
}
