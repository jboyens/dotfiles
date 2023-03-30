{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.services.kanshi;
in {
  options.modules.desktop.services.kanshi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      profiles = {
        Home = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
              position = "6940,2160";
              status = "enable";
            }
            {
              criteria = "LG Electronics LG Ultra HD 0x00011A21";
              mode = "3840x2160@60Hz";
              position = "0,0";
              scale = 1.0;
              status = "enable";
            }
            {
              criteria =
                "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
              mode = "3840x2160@60Hz";
              position = "3840,0";
              scale = 1.0;
              status = "enable";
            }
          ];
        };

        Mobile = {
          outputs = [{
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "0,0";
            status = "enable";
          }];
        };
      };
    };
  };
}
