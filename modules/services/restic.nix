{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.restic;
in {
  options.modules.services.restic = {
    enable = mkBoolOpt false;
    backups = {
      workspace = {
        enable = mkEnableOption false;
        paths = mkOption {
          type = types.listOf types.path;
          default = [ "${config.user.home}/Workspace" ];
        };
      };
      home = {
        enable = mkEnableOption false;
        paths = mkOption {
          type = types.listOf types.path;
          default = [ "${config.user.home}" ];
        };
      };
      mail = {
        enable = mkEnableOption false;
        paths = mkOption {
          type = types.listOf types.path;
          default = [ "${config.user.home}/.mail" ];
        };
      };
    };
    pruneOpts = mkOption {
      type = types.listOf types.str;
      default = [
        "--keep-hourly 24"
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
    };
  };

  config = mkIf cfg.enable {
    services.restic.backups = mkMerge [
      (mkIf cfg.backups.workspace.enable {
        Workspace = {
          user = config.user.name;
          paths = cfg.backups.workspace.paths;
          repository = "rest:http://192.168.86.34:8899/Workspace-restic";
          pruneOpts = cfg.pruneOpts;
          extraBackupArgs = [
            "-e /home/jboyens/Workspace/shyft_api_server/log"
            "-e /home/jboyens/Workspace/shyft_api_server/tmp"
            "-e /home/jboyens/Workspace/warehouser/log"
            "-e /home/jboyens/Workspace/warehouser/tmp"
          ];
          timerConfig = { OnCalendar = "hourly"; };
          passwordFile = "/home/jboyens/.secrets/backup.secret";
        };
      })
      (mkIf cfg.backups.mail.enable {
        Mail = {
          user = config.user.name;
          paths = cfg.backups.mail.paths;
          repository = "rest:http://192.168.86.34:8899/Mail-restic";
          pruneOpts = cfg.pruneOpts;
          timerConfig = { OnCalendar = "hourly"; };
          passwordFile = "/home/jboyens/.secrets/backup.secret";
        };
      })
      (mkIf cfg.backups.home.enable {
        Home = {
          user = config.user.name;
          paths = cfg.backups.home.paths;
          repository = "rest:http://192.168.86.34:8899/home-restic";
          pruneOpts = cfg.pruneOpts;
          extraBackupArgs =
            [ "--exclude-file /home/jboyens/restic-exclude.txt" "-x" ];
          timerConfig = { OnCalendar = "hourly"; };
          passwordFile = "/home/jboyens/.secrets/backup.secret";
        };
      })
    ];
  };
}
