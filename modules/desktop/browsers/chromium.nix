# modules/browser/chromium.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.browsers.chromium;
  mychromium = (pkgs.chromium.override {
    enableWideVine = true;
  });
in {
  options.modules.desktop.browsers.chromium = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mychromium
      (makeDesktopItem {
        name = "Google Meet";
        desktopName = "Google Meet";
        genericName = "Open Google Meet";
        icon = "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Profile_1";
        exec = "${mychromium}/bin/chromium \"--profile-directory=Profile 1\" --app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan --ozone-platform-hint=auto";
        categories = ["Network"];
      })
    ];
  };
}
