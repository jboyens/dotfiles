{ config, lib, ... }:

with lib; {
  networking.hosts = let
    hostConfig = {
      "192.168.86.76" = [ "kitt" ];
      "192.168.86.100" = [ "irongiant" ];
      "192.168.86.161" = [ "avocado" ];
      "192.168.86.34" = [ "mediaserver" "nas" "backup-host" ];
      "192.168.49.2" = [ "dev" "dev.fooninja.org" ];
    };
    hosts = flatten (attrValues hostConfig);
    hostName = config.networking.hostName;
  in mkIf (builtins.elem hostName hosts) hostConfig;

  ## Location config -- since Seattle is my 127.0.0.1
  time.timeZone = mkDefault "America/Los_Angeles";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "America/Los_Angeles" then {
    latitude = 47.6062;
    longitude = -122.3321;
  } else
    { });

  # So thw bitwarden CLI knows where to find my server.
  modules.shell.bitwarden.config.server = "bw.fooninja.org";


  ## Not using syncthing atm
  services.syncthing = {
    # Purge folders not declaratively configured!
    overrideFolders = true;
    overrideDevices = true;
    devices = {
      mediaserver.id  = "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
      kitt.id  = "Z6KVBYP-VAKL7WV-GQECKAS-FU23XXB-Q5G2RR3-3JQHCHY-BLGK4UM-B3OETA2";
      pixel3xl.id = "MMO6WXY-ZLRNVVG-FEJNHFQ-S6RLBRL-JJ57M5R-ARZHFDZ-NYXUYVJ-OAFIVQN";
    };
    folders =
      let mkShare = devices: type: paths: attrs: (rec {
            inherit devices type;
            path = if lib.isAttrs paths
                   then paths."${config.networking.hostName}"
                   else paths;
            watch = false;
            rescanInterval = 3600; # every hour
            enable = lib.elem config.networking.hostName devices;
          } // attrs);
      in {
        documents = mkShare [ "mediaserver" "kitt" "pixel3xl" ] "sendreceive" "${config.user.home}/Documents"
          { watch = true;
            rescanInterval = 300; }; # every 5 minutes
        secrets = mkShare [ "mediaserver" "kitt" ] "sendreceive" "${config.user.home}/.secrets"
          { watch = true;
            rescanInterval = 3600; }; # every hour
        # serverBackup = mkShare [ "ao" "kiiro" ] "sendonly" "/run/backups"
        # mainBackup = mkShare [ "kuro" "kiiro" ] "sendreceive" #         "/usr/store"
        #   { versioning = {
        #       type = "staggered";
        #       params.maxAge = "356";
        #     }; };
      };
  };
}
