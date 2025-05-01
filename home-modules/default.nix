{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs) system;
  inherit (self.packages."${system}") moment-staging;
in {
  home.packages = with pkgs; [
    widevine-cdm

    ghostty

    gnomeExtensions.tiling-shell

    moment-staging
  ];

  xdg.mimeApps = {
    enable = false;

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
