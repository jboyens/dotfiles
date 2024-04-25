{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs;
in {
  fontDir.enable = true;

  enableGhostscriptFonts = true;
  enableDefaultPackages = true;

  packages = with pkgs; [
    (pkgs.iosevka-bin.override {variant = "Etoile";})
    # (pkgs.iosevka-bin.override {variant = "etoile";})
    (pkgs.iosevka-bin.override {variant = "Aile";})
    # (pkgs.iosevka-bin.override {variant = "aile";})
    inputs.cells.common.packages.pragmasevka
    pkgs.noto-fonts-emoji

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
    (iosevka-bin.override {variant = "SGr-IosevkaTerm";})
    # (iosevka-bin.override {variant = "sgr-iosevka-term";})
    iosevka-comfy.comfy
    iosevka-comfy.comfy-duo
    iosevka-comfy.comfy-fixed
    _3270font
    jetbrains-mono
    hack-font
    ibm-plex
    oxygenfonts
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  fontconfig.defaultFonts = {
    serif = ["Iosevka Etoile"];
    sansSerif = ["Iosevka Aile"];
    monospace = ["Pragmasevka"];
    emoji = ["Noto Color Emoji"];
  };
}
