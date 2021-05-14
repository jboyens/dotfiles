{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.slack;
in {
  options.modules.desktop.apps.slack = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.slack

      (makeDesktopItem {
        name = "slack-wayland";
        desktopName = "Slack (Wayland)";
        genericName = "Open Slack on Wayland";
        icon = "slack";
        exec = "${unstable.electron}/bin/electron ${unstable.slack}/lib/slack/resources/app.asar --enable-features=UseOzonePlatform --ozone-platform=wayland";
        categories = "Network";
      })
    ];
  };
}
