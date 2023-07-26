{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  # mychromium = nixpkgs.chromium.override {
  #   enableWideVine = true;
  # };
in {
  home.packages = with nixpkgs; [
    # mychromium
    google-chrome
    (makeDesktopItem {
      name = "Google Meet";
      desktopName = "Google Meet";
      genericName = "Open Google Meet";
      icon = "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Default";
      exec = "google-chrome-stable \"--profile-directory=Default\" --app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan --ozone-platform-hint=auto";
      categories = ["Network"];
    })
  ];
}
