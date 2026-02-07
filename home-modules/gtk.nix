{pkgs, ...}: {
  home.packages = [
    pkgs.adwaita-icon-theme
    pkgs.gnome-themes-extra
    pkgs.bibata-cursors
  ];

  gtk = {
    enable = true;

    gtk2.enable = false;

    gtk3.extraConfig = {
      gtk-fallback-icon-theme = "Adwaita";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    gtk4.extraConfig = {
      gtk-fallback-icon-theme = "Adwaita";
      gtk-xft-hinting = "1";
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "none";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
