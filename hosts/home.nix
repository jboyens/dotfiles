{ config, lib, ... }:

with lib; {
  networking.hosts = let
    hostConfig = {
      "192.168.86.76" = [ "kitt" ];
      "192.168.86.100" = [ "irongiant" ];
      "192.168.86.161" = [ "avocado" ];
      "192.168.86.34" = [ "mediaserver" "nas" "backup-host" ];
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

  # services.syncthing.declarative = {
  #   devices = {
  #     kuro.id  = "4UJSUBN-V7LCISG-6ZE7SBN-YPXM5FQ-CE7CD2U-W4KZC7O-4HUZZSW-6DXAGQQ";
  #     shiro.id = "G4DUO25-AMQQIWS-SRZE5TJ-43CCQZJ-5ULEZBS-P2LMZZU-V5JA5CS-6X7RLQK";
  #     kiiro.id = "DPQT4XQ-Q4APAYJ-T7P4KMY-YBLDKLC-7AU5Y4S-VGT3DDT-TMZZEIX-GBA7DAM";
  #   };
  #   folders =
  #     let mkShare = name: devices: type: path: rec {
  #           inherit devices type path;
  #           watch = false;
  #           rescanInterval = 3600 * 4;
  #           enabled = lib.elem config.networking.hostname devices;
  #         };
  #     in {
  #       projects = mkShare "projects" [ "kuro" "shiro" ] "sendrecieve" "${config.user.home}/projects";
  #     };
  # };
}
