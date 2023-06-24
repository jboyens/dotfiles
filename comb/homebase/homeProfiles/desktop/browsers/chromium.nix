{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  mychromium = nixpkgs.chromium.override {
    enableWideVine = true;
  };
in {
  home.packages = with nixpkgs; [
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
}
