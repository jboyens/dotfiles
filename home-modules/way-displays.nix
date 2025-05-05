_: let
  left = {
    name = "LG Electronics LG Ultra HD 0x00011A21";
    mode = "3840x2160@60Hz";
  };

  right = {
    name = "LG Electronics LG ULTRAWIDE 205NTLE54632";
    mode = "3440x1440@160Hz";
  };
in {
  services.way-displays = {
    enable = true;
    settings = {
      ARRANGE = "ROW";
      ALIGN = "TOP";
      ORDER = [
        "DP-2"
        "DP-1"
      ];
      SCALING = true;
      AUTO_SCALE = true;
      VRR_OFF = [
        "DP-2"
        "DP-1"
      ];
    };
  };

  wayland.windowManager.sway.config.output = {
    "${left.name}" = {
      inherit (left) mode;

      position = "0,0";
      subpixel = "rgb";
    };

    "${right.name}" = {
      inherit (right) mode;

      position = "3840,370";
      subpixel = "rgb";
    };
  };
}
