{
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs lib;
in {
  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.extraConfig = {
      gtk-fallback-icon-theme = "gnome";
      gtk-application-prefer-dark-theme = "true";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    gtk4.extraConfig = {
      gtk-fallback-icon-theme = "gnome";
      gtk-application-prefer-dark-theme = "true";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    theme = {
      package = lib.mkForce (pkgs.catppuccin-gtk.override {
        accents = ["yellow"];
        size = "standard";
        variant = "frappe";
      });
      name = lib.mkForce "Catppuccin-Frappe-Standard-Yellow-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    iconTheme = {
      package = pkgs.tela-circle-icon-theme;
      name = "Tela-circle-dark";
    };
  };
}
