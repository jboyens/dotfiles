{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  fontDir.enable = true;
  enableGhostscriptFonts = true;
  enableDefaultFonts = true;
  fonts = with nixpkgs; [
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
    (nerdfonts.override {fonts = ["FiraCode" "FiraMono"];})
  ];
}
