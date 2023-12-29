{...}: let
  # baseRepo = "sftp://jboyens@192.168.86.34:2223//backup";
  baseRepo = "rest:http://192.168.86.34:8899";

  pruneOpts = [
    "--keep-hourly 24"
    "--keep-daily 7"
    "--keep-weekly 5"
    "--keep-monthly 12"
    "--keep-yearly 75"
  ];
in {
  services.restic.backups = {
    Workspace = {
      user = "jboyens";
      paths = ["/home/jboyens/Workspace"];
      repository = "${baseRepo}/Workspace-restic";
      inherit pruneOpts;
      extraBackupArgs = [
        "-e /home/jboyens/Workspace/shyft_api_server/log"
        "-e /home/jboyens/Workspace/shyft_api_server/tmp"
        "-e /home/jboyens/Workspace/warehouser/log"
        "-e /home/jboyens/Workspace/warehouser/tmp"
      ];
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = 900;
      };
      passwordFile = "/home/jboyens/.secrets/backup.secret";
    };

    Mail = {
      user = "jboyens";
      paths = ["/home/jboyens/.mail"];
      repository = "${baseRepo}/Mail-restic";
      inherit pruneOpts;
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = 900;
      };
      passwordFile = "/home/jboyens/.secrets/backup.secret";
    };

    Home = {
      user = "jboyens";
      paths = ["/home/jboyens"];
      repository = "${baseRepo}/home-restic";
      inherit pruneOpts;
      extraBackupArgs = ["--exclude-file /home/jboyens/restic-exclude.txt" "-x"];
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = 900;
      };
      passwordFile = "/home/jboyens/.secrets/backup.secret";
    };
  };

  systemd.services.restic-backups-Home.serviceConfig.CPUQuota = "200%";
  systemd.services.restic-backups-Home.serviceConfig.IOWeight = "1";
  systemd.services.restic-backups-Mail.serviceConfig.CPUQuota = "200%";
  systemd.services.restic-backups-Mail.serviceConfig.IOWeight = "1";
  systemd.services.restic-backups-Workspace.serviceConfig.CPUQuota = "200%";
  systemd.services.restic-backups-Workspace.serviceConfig.IOWeight = "1";
}
