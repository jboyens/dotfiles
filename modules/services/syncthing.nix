{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.syncthing.enable {
    services.syncthing = {
      enable = true;
      package = pkgs.unstable.syncthing;
      openDefaultPorts = true;
      user = config.my.username;
      configDir = "/home/${config.my.username}/.config/syncthing";
      dataDir = "/home/${config.my.username}/.local/share/syncthing";
      declarative = {
        devices = {
          mediaserver.id =
            "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
          alita.id =
            "2J42GVG-XBN4U67-T7MZTLJ-HQRHEO7-FALMDB5-4MMS5IE-EUEG52T-QTOOAQQ";
          flexo.id =
            "5ERIUM3-FHYCLVE-FJCEP53-VJWIQDN-5B3H5QH-KLAI2UD-PHFW6AP-GGOYKAK";
          pixel3xl.id =
            "MMO6WXY-ZLRNVVG-FEJNHFQ-S6RLBRL-JJ57M5R-ARZHFDZ-NYXUYVJ-OAFIVQN";
        };
        folders = let
          deviceEnabled = devices: lib.elem config.networking.hostName devices;
          deviceType = devices:
            if deviceEnabled devices then "sendreceive" else "receiveonly";
        in {
          secrets = rec {
            devices = [ "alita" "flexo" "mediaserver" ];
            path = "/home/${config.my.username}/.secrets";
            watch = true;
            rescanInterval = 3600;
            type = deviceType [ "alita" "mediaserver" "flexo" ];
            enable = deviceEnabled devices;
          };

          Workspace = rec {
            id = "d2ptm-vzs72";
            devices = [ "alita" "mediaserver" "flexo" ];
            path = "/home/${config.my.username}/Workspace";
            watch = true;
            rescanInterval = 3600;
            type = deviceType [ "alita" "mediaserver" "flexo" ];
            enable = deviceEnabled devices;
          };

          Documents = rec {
            id = "rkurc-zmhak";
            devices = [ "alita" "mediaserver" "flexo" "pixel3xl" ];
            path = "/home/${config.my.username}/Documents";
            watch = true;
            rescanInterval = 3600;
            type = deviceType [ "alita" "mediaserver" "flexo" ];
            enable = deviceEnabled devices;
          };
        };
      };
    };
  };
}
