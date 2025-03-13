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
        xwayland_satellite = "${lib.getExe pkgs.xwayland-satellite}";
        kanshi = "${lib.getExe pkgs.kanshi}";
        waybar = "${lib.getExe pkgs.waybar}";
      };
    };
  };
}
