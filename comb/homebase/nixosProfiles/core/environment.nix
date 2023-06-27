{
  inputs,
  cell,
}: {
  variables = {
    DOTFILES = "/home/jboyens/.config/dotfiles";
    DOTFILES_BIN = "/home/jboyens/.config/dotfiles/bin";
    ZDOTDIR = "/home/jboyens/.config/zsh";
    ZSH_CACHE = "/home/jboyens/.config/zsh";
    ZGEN_DIR = "/home/jboyens/.local/share/zgenom";

    XDG_CONFIG_HOME = "/home/jboyens/.config";

    GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
  };

  systemPackages = with inputs.nixpkgs; [
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
    neovim
    wget
    whois

    nixfmt
    nixpkgs-fmt
    alejandra

    lm_sensors

    fasd
  ];
}
