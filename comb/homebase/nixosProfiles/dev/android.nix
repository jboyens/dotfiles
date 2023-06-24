{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  users.users.jboyens.extraGroups = ["adbusers"];

  programs.adb.enable = true;

  services.udev.packages = [nixpkgs.android-udev-rules];
}
