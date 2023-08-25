{config}: let
  laptop = {
    name = "eDP-1";
    mode = "1920x1200@60Hz";
  };

  left = {
    name = "LG Electronics LG Ultra HD 0x00011A21";
    mode = "3840x2160@60Hz";
  };

  right = {
    name = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
    mode = "3840x2160@60Hz";
  };
in {
  services.kanshi = {
    enable = true;
    profiles = {
      Home = {
        outputs = [
          {
            inherit (laptop) mode;

            criteria = laptop.name;
            position = "6940,2160";
          }
          {
            inherit (left) mode;

            criteria = left.name;
            position = "0,0";
          }
          {
            inherit (right) mode;

            criteria = right.name;
            position = "3840,0";
          }
        ];
      };
      Mobile = {
        outputs = [
          {
            inherit (laptop) mode;

            criteria = laptop.name;
            position = "0,0";
            scale = 1.0;
          }
        ];
      };
    };
  };

  wayland.windowManager.sway.config.output = {
    "*" = {
      bg = "${toString config.styling.image} fill";
    };

    "${laptop.name}" = {
      inherit (laptop) mode;

      position = "6940,2160";
    };

    "${left.name}" = {
      inherit (left) mode;

      position = "0,0";
    };

    "${right.name}" = {
      inherit (right) mode;

      position = "3840,0";
    };
  };
}
