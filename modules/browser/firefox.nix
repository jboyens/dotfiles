# modules/browser/firefox.nix --- https://www.mozilla.org/en-US/firefox
#
# Oh firefox, gateway to the interwebs, devourer of ram. Give onto me your
# infinite knowledge and shelter me from ads.

{ config, lib, pkgs, ... }: {
  my.packages = with pkgs; [
    (firefox.override {
      extraNativeMessagingHosts = [ passff-host tridactyl-native ];
    })
    (pkgs.writeScriptBin "firefox-private" ''
      #!${stdenv.shell}
      ${firefox}/bin/firefox --private-window "$@"
    '')
    (makeDesktopItem {
      name = "firefox-private";
      desktopName = "Firefox (Private)";
      genericName = "Open a private Firefox window";
      icon = "firefox";
      exec = "${firefox}/bin/firefox --private-window";
      categories = "Network";
    })
  ];

  my.env.BROWSER = "firefox";
  my.env.XDG_DESKTOP_DIR = "$HOME"; # prevent firefox creating ~/Desktop
  my.home.xdg = {
    configFile."tridactyl/tridactylrc".source = <config/tridactyl/tridactylrc>;
  };
}
