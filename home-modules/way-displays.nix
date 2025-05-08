{osConfig, ...}: {
  services.way-displays = {
    enable = true;
    settings = {
      ARRANGE = "ROW";
      ALIGN = "TOP";
      ORDER = [
        "eDP-1"
        "DP-6"
        "DP-2"
        "DP-1"
      ];
      SCALING =
        if (osConfig.networking.hostName == "mechagodzilla")
        then false
        else true;
      AUTO_SCALE = true;
      VRR_OFF = [
        "eDP-1"
        "DP-6"
        "DP-2"
        "DP-1"
      ];
    };
  };

  wayland.windowManager.sway.config.output = {};
}
