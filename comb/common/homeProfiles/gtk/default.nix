{
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs lib;
in {
  home.packages = [
    # (pkgs.catppuccin-gtk.override {
    #   accents = ["yellow"];
    #   size = "standard";
    #   variant = "frappe";
    # })
    pkgs.catppuccin-gtk
    pkgs.tela-circle-icon-theme
    pkgs.gnome.adwaita-icon-theme
    pkgs.gnome.gnome-themes-extra
    pkgs.bibata-cursors
  ];

  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.extraConfig = {
      gtk-fallback-icon-theme = "Adwaita:dark";
      # gtk-application-prefer-dark-theme = "true";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    gtk4.extraConfig = {
      gtk-fallback-icon-theme = "Adwaita:dark";
      # gtk-application-prefer-dark-theme = "true";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    theme = {
      # package = lib.mkForce (pkgs.catppuccin-gtk.override {
      #   accents = ["yellow"];
      #   size = "standard";
      #   variant = "frappe";
      # });
      # package = lib.mkForce (pkgs.catppuccin-gtk);
      # package = lib.mkForce pkgs.gnome.gnome-themes-extra;
      # name = lib.mkForce "Adwaita:dark";
      # name = lib.mkForce "Catppuccin-Frappe-Standard-Yellow-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    iconTheme = {
      package = pkgs.tela-circle-icon-theme;
      name = "Tela-circle-dark";
      # name = "Adwaita:dark";
      # package = pkgs.gnome.adwaita-icon-theme;
    };
  };
}
