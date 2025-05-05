{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.configFile = {
    "niri/config.kdl" = {
      source = pkgs.substituteAll {
        src = ./niri.kdl;
        fuzzel = "${lib.getExe pkgs.fuzzel}";
        ghostty = "${lib.getExe pkgs.ghostty}";
        swaylock = "${lib.getExe pkgs.swaylock}";
        waybar = "${lib.getExe pkgs.waybar}";
        waydisplays = "${lib.getExe pkgs.way-displays}";
        xwayland_satellite = "${lib.getExe pkgs.xwayland-satellite}";
      };
    };
  };
}
