{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.services.gammastep;
in {
  options.modules.desktop.services.gammastep = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.services.gammastep = {
      enable = true;
      latitude = "47.553341";
      longitude = "-122.370537";
      provider = "manual";
      tray = false;
    };
  };
}
