{pkgs, ...}: {
  home.packages = with pkgs; [
    widevine-cdm

    ghostty

    gnomeExtensions.tiling-shell
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/sgnl" = "signal-desktop.desktop";
      "x-scheme-handler/signalcaptcha" = "signal-desktop.desktop";
      "application/pdf" = "xdg-desktop-portal-gtk.desktop";
    };
  };

  dconf = {
    enable = true;

    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        tiling-shell.extensionUuid
      ];
    };
  };
}
