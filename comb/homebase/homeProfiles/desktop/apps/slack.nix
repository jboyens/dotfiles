{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.stdenv) system;
  # locked to old version due to screen sharing issues
  # mySlack = (import inputs.nixpkgs-unstable {
  #   inherit (pkgs) system; config.allowUnfree = true;
  # }).slack;
  mySlack = nixpkgs.slack;
  # mySlack =
  #   (import (builtins.fetchTarball {
  #       url = "https://github.com/NixOS/nixpkgs/archive/b3a285628a6928f62cdf4d09f4e656f7ecbbcafb.tar.gz";
  #       sha256 = "sha256:02lj0hy7cbpbdl0x7wx58aqbmn8chwplqpgrwvca8nmgn65ibm1i";
  #     }) {
  #       inherit system;
  #
  #       config.allowUnfree = true;
  #     })
  #   .slack;
in {
  home.packages = with nixpkgs; [
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
}
