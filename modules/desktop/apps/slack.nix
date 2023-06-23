{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.apps.slack;
  # locked to old version due to screen sharing issues
  # mySlack = (import inputs.nixpkgs-unstable {
  #   inherit (pkgs) system; config.allowUnfree = true;
  # }).slack;
  mySlack = pkgs.my.slack;
  # mySlack = pkgs.slack;
in {
  options.modules.desktop.apps.slack = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mySlack
      (makeDesktopItem {
        name = "slack-wayland";
        desktopName = "Slack (Wayland)";
        genericName = "Open Slack as a Wayland app";
        icon = "slack";
        exec = "${mySlack}/bin/slack --ozone-platform-hint=auto";
        categories = ["Network"];
      })
    ];
  };
}
