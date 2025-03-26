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
  services.kanshi = {
    enable = false;
    settings = [
      {
        profile = {
          name = "Office";
          outputs = [
            {
              criteria = "Hewlett Packard HP Pavilion32 CNC71107KL";
              mode = "2560x1440@60Hz";
              position = "1920,0";
            }
            {
              criteria = "BOE 0x0A5C Unknown";
              mode = "1920x1080@60Hz";
              position = "0,270";
            }
          ];
        };
      }
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
              inherit (right) mode;

              criteria = right.name;
              position = "3840,370";
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

    "${right.name}" = {
      inherit (right) mode;

      position = "3840,370";
      subpixel = "rgb";
    };
  };
}
