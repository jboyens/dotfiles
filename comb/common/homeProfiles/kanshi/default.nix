{config}: let
  left = {
    name = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
    mode = "3840x2160@60Hz";
  };

  center = {
    name = "LG Electronics LG Ultra HD 0x00011A21";
    mode = "3840x2160@60Hz";
  };

  right = {
    name = "eDP-1";
    mode = "1920x1200@60Hz";
  };
in {
  services.kanshi = {
    enable = true;
    profiles = {
      Home = {
        outputs = [
          {
            inherit (left) mode;

            criteria = left.name;
            position = "0,0";
          }
          {
            inherit (center) mode;

            criteria = center.name;
            position = "3840,0";
          }
          {
            inherit (right) mode;

            criteria = right.name;
            position = "7680,960";
          }
        ];
      };
      Mobile = {
        outputs = [
          {
            inherit (right) mode;

            criteria = right.name;
            position = "0,0";
            scale = 1.0;
          }
        ];
      };
    };
  };

  wayland.windowManager.sway.config.output = {
    "${left.name}" = {
      inherit (left) mode;

      position = "0,0";
    };

    "${center.name}" = {
      inherit (center) mode;

      position = "3840,0";
    };

    "${right.name}" = {
      inherit (right) mode;

      position = "7680,960";
    };
  };
}
