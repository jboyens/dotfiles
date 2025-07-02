{
  osConfig,
  lib,
  ...
}: {
  services.way-displays = let
    isMechagodzilla = osConfig.networking.hostName == "mechagodzilla";
  in {
    enable = true;
    settings = {
      ARRANGE = "ROW";
      ALIGN =
        if isMechagodzilla
        then "BOTTOM"
        else "TOP";
      ORDER = [
        "eDP-1"
        "DP-3"
        "DP-6"
        "DP-2"
        "DP-1"
      ];
      SCALING = true;
      SCALE = [
        (lib.mkIf isMechagodzilla {
          NAME_DESC = "DP-3";
          SCALE = "1.5";
        })
      ];
      AUTO_SCALE =
        if isMechagodzilla
        then false
        else true;
      VRR_OFF = [
        "eDP-1"
        "DP-3"
        "DP-6"
        "DP-2"
        "DP-1"
      ];
    };
  };

  wayland.windowManager.sway.config.output = {};
}
