{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = config.my.username;
    configDir = "/home/${config.my.username}/.config/syncthing";
    dataDir = "/home/${config.my.username}/.local/share/syncthing";
    declarative = {
      devices = {
        mediaserver.id = "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
        alita.id = "2J42GVG-XBN4U67-T7MZTLJ-HQRHEO7-FALMDB5-4MMS5IE-EUEG52T-QTOOAQQ";
        flexo.id = "L5H7E6H-APATPP5-6E4VKS2-HVVASML-SURPAP6-SHMKO7R-N2U2ZJ4-TZCG5QZ";
        pixel3xl.id = "MMO6WXY-ZLRNVVG-FEJNHFQ-S6RLBRL-JJ57M5R-ARZHFDZ-NYXUYVJ-OAFIVQN";
      };
      folders =
        let deviceEnabled = devices: lib.elem config.networking.hostName devices;
            deviceType = devices:
              if deviceEnabled devices
              then "sendreceive"
              else "receiveonly";
        in {
          secrets = rec {
            devices = [ "mediaserver" ];
            path = "/home/${config.my.username}/.secrets";
            watch = true;
            rescanInterval = 3600;
            type = deviceType ["mediaserver"];
            enable = deviceEnabled devices;
          };

          Workspace = rec {
            devices = [ "mediaserver" "flexo" "pixel3xl" ];
            path = "/home/${config.my.username}/workspace";
            watch = true;
            rescanInterval = 3600;
            type = deviceType ["mediaserver"];
            enable = deviceEnabled devices;
          };

          Documents = rec {
            devices = [ "mediaserver" "flexo" "pixel3xl" ];
            path = "/home/${config.my.username}/Documents";
            watch = true;
            rescanInterval = 3600;
            type = deviceType ["mediaserver"];
            enable = deviceEnabled devices;
          };
        };
    };
  };
}
