{
  inputs,
  cell,
}: {
  systemPackages = with inputs.nixpkgs; [
    bind
    binutils
    bottom
    cacert
    cached-nix-shell
    coreutils
    curl
    direnv
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
    vim
    wget
    whois

    lm_sensors
  ];
}
