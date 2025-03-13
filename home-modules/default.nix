{pkgs, ...}: {
  home.packages = with pkgs; [
    widevine-cdm

    ghostty
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
}
