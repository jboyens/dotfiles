{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.geoclue2;
in {
  options.modules.services.geoclue2 = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    services.geoclue2 = {
      enable = true;
      enableDemoAgent = false;
      appConfig = {
        "gammastep" = {
          isAllowed = true;
          isSystem = false;
          users = [];
        };
        "redshift" = {
          isAllowed = true;
          isSystem = false;
          users = [];
        };
        "org.freedesktop.DBus" = {
          isAllowed = true;
          isSystem = true;
          users = [];
        };
      };
    };
  };
}
