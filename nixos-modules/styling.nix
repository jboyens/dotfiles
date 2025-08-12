{
  inputs,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;

    # base16Scheme = "${inputs.base16-schemes}/base16/onedark.yaml";

    # use IFD due to tinted-theming/schemes @ 61058a8d2e2bd4482b53d57a68feb56cdb991f0b
    # which causes a parse error otherwise due to the addition of "#" marks in
    # front of all the colors values
    base16Scheme = {
      # yaml = "${inputs.base16-schemes}/base16/onedark.yaml";
      # yaml = "${inputs.base16-schemes}/base16/material-palenight.yaml";
      # yaml = "${inputs.base16-schemes}/base16/summercamp.yaml";
      yaml = "${inputs.base16-schemes}/base16/nord.yaml";
      use-ifd = "always";
    };

    # image = /home/jboyens/hyprdots/Configs/.config/swww/Catppuccin-Mocha/aesthetic_deer.png;
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/1p/wallhaven-1pewdv.jpg";
      sha256 = "sha256-4thxoM75RUEHWZGT2e7S/KsdLZIJqAxzKJz/K2GgZ6U=";
    };
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override {variant = "Etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "Aile";};
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin;
        name = "Iosevka";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        desktop = 12;
        terminal = 10;
        popups = 12;
      };
    };
  };
}
