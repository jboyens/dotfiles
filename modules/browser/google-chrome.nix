# modules/browser/google-chrome.nix
#
# Literal spyware, with a decent developer console

{ config, lib, pkgs, ... }:
{
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
}
