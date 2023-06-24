{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    signal-desktop
    (makeDesktopItem {
      name = "signal-desktop-wayland";
      desktopName = "Signal Desktop (Wayland)";
      genericName = "Open Signal Desktop as a Wayland app";
      icon = "signal-desktop";
      exec = "${signal-desktop}/bin/signal-desktop --ozone-platform-hint=auto";
      categories = ["Network"];
    })
  ];
}
