{
  inputs,
  cell,
}: {
  enableDefaultFonts = true;

  fonts = [
    (inputs.nixpkgs.iosevka-bin.override {variant = "etoile";})
    (inputs.nixpkgs.iosevka-bin.override {variant = "aile";})
    inputs.cells.homebase.packages.pragmasevka
    inputs.nixpkgs.noto-fonts-emoji
  ];

  fontconfig.defaultFonts = {
    serif = ["Iosevka Etoile"];
    sansSerif = ["Iosevka Aile"];
    monospace = ["Pragmasevka"];
    emoji = ["Noto Color Emoji"];
  };
}
