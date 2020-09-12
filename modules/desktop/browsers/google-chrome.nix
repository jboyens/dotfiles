# modules/browser/google-chrome.nix
#
# Literal spyware, with a decent developer console

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.browsers.google-chrome = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.browsers.google-chrome.enable {
    my.packages = with pkgs; [
      google-chrome
      (pkgs.writeScriptBin "google-chrome-stable-private" ''
        #!${stdenv.shell}
        ${google-chrome}/bin/google-chrome-stable --incognito "$@"
      '')
      (makeDesktopItem {
        name = "google-chrome-private";
        desktopName = "Google Chrome (Private)";
        genericName = "Open a private Google Chrome window";
        icon = "google-chrome";
        exec = "${google-chrome}/bin/google-chrome-stable --incognito";
        categories = "Network";
      })
    ];
  };
}
