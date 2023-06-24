{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    brave
    (makeDesktopItem {
      name = "brave-private";
      desktopName = "Brave Web Browser";
      genericName = "Open a private Brave window";
      icon = "brave";
      exec = "${brave}/bin/brave --incognito";
      categories = ["Network"];
    })
  ];
}
