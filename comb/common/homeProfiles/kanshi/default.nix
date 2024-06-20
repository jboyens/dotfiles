{config}: let
  left = {
    name = "LG Electronics LG Ultra HD 0x00011A21";
    mode = "3840x2160@60Hz";
  };

  center = {
    name = "LG Electronics LG ULTRAWIDE 205NTLE54632";
    mode = "3440x1440@100Hz";
  };

  right = {
    name = "eDP-1";
    mode = "1920x1200@60Hz";
  };
in {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "Home";
          outputs = [
            {
              inherit (left) mode;

              criteria = left.name;
              position = "0,0";
            }
            {
              inherit (center) mode;

              criteria = center.name;
              position = "3840,370";
            }
            {
              inherit (right) mode;

              criteria = right.name;
              position = "7280,750";
            }
          ];
        };
      }
      {
        profile = {
          name = "Mobile";
          outputs = [
            {
              inherit (right) mode;

              criteria = right.name;
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };

  wayland.windowManager.sway.config.output = {
    "${left.name}" = {
      inherit (left) mode;

      position = "0,0";
      subpixel = "rgb";
    };

    "${center.name}" = {
      inherit (center) mode;

      position = "3840,370";
      subpixel = "rgb";
    };

    "${right.name}" = {
      inherit (right) mode;

      position = "7280,750";
      subpixel = "rgb";
    };
  };
}
