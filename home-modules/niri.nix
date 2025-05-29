{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.configFile = {
    "niri/config.kdl" = {
      source = pkgs.replaceVars ./niri.kdl {
        waybar = "${lib.getExe pkgs.waybar}";
        waydisplays = "${lib.getExe pkgs.way-displays}";
        xwayland_satellite = "${lib.getExe pkgs.xwayland-satellite}";
        DEFAULT_AUDIO_SINK = null;
        DEFAULT_AUDIO_SOURCE = null;
      };
    };
  };
}
