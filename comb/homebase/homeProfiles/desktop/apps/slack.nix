{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  # locked to old version due to screen sharing issues
  # mySlack = (import inputs.nixpkgs-unstable {
  #   inherit (pkgs) system; config.allowUnfree = true;
  # }).slack;
  mySlack = nixpkgs.slack;
  # mySlack = pkgs.slack;
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
