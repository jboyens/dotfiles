{
  pkgs,
  config,
  self,
  ...
}: let
  inherit (pkgs) system;
  inherit (self.packages."${system}") moment-staging;
in {
  home = {
    packages = with pkgs; [
      widevine-cdm

      ghostty

      gnomeExtensions.tiling-shell

      moment-staging

      flatpak
      gnome-software
    ];

    sessionVariables = let
      inherit (config.home.sessionVariables) XDG_DATA_HOME XDG_CONFIG_HOME XDG_CACHE_HOME;
    in {
      ANDROID_USER_HOME = "${XDG_DATA_HOME}/android";
      AWS_SHARED_CREDENTIALS_FILE = "${XDG_CONFIG_HOME}/aws/credentials";
      AWS_CONFIG_FILE = "${XDG_CONFIG_HOME}/aws/config";
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      IMAPFILTER_HOME = "${XDG_CONFIG_HOME}/imapfilter";
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      PKG_CACHE_PATH = "${XDG_DATA_HOME}/pkg-cache";
      PGPASSFILE = "${XDG_CONFIG_HOME}/pg/pgpass";
      PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
      BUNDLE_USER_CONFIG = "${XDG_CONFIG_HOME}/bundle";
      BUNDLE_USER_CACHE = "${XDG_CACHE_HOME}/bundle";
      BUNDLE_USER_PLUGIN = "${XDG_DATA_HOME}/bundle";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      W3M_DIR = "${XDG_DATA_HOME}/w3m";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";
    };

    shellAliases = {
      adb = ''HOME="$XDG_DATA_HOME"/android adb'';
      wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
    };
  };

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

  dconf.enable = true;
}
