{
  inputs,
  cell,
  ...
}: let
  inherit (cell) pkgs;
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;

    # base16Scheme = "${inputs.catppuccin-base16}/base16/frappe.yaml";
    base16Scheme = "${inputs.base16-schemes}/base16/onedark.yaml";
    image = /home/jboyens/hyprdots/Configs/.config/swww/Catppuccin-Mocha/aesthetic_deer.png;
    polarity = "dark";

    targets.firefox.profileNames = ["default"];
    targets.gnome.enable = true;
    targets.gtk.enable = true;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override {variant = "Etoile";};
        # package = pkgs.iosevka-bin.override {variant = "etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "Aile";};
        # package = pkgs.iosevka-bin.override {variant = "aile";};
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
