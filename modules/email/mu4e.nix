{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.email.mu4e;
in {
  options.modules.email.mu4e = {
    enable = mkBoolOpt false;
    package = mkOption  {
      type = types.package;
      default = pkgs.offlineimap;
      defaultText = "pkgs.offlineimap";
      description = "Offlineimap derivation to use";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cfg.package
      # don't install mu4e here
      # mu
      imapfilter
      unstable.isync
    ];

    systemd.user.services."goimapnotify@" = {
      enable = true;
      description = "IMAP notifier using IDLE, golang version.";
      unitConfig = {
        ConditionPathExists="%h/.config/imapnotify/%I/notify.conf";
        After="network.target";
      };
      serviceConfig = {
        ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
        Restart = "always";
        RestartSec = "30";
      };
      path = with pkgs; [ isync mu ];
      wantedBy = [ "default.target" ];
    };

    systemd.user.timers."mbsync" = {
      enable = true;
      description = "call mbsync on all accounts every 15 m";
      unitConfig = {
        ConditionPathExists="%h/.mbsyncrc";
      };
      timerConfig = {
        Unit = "mbsync.service";
        OnBootSec="30s";
        OnUnitInactiveSec="15m";
        Persistent = "true";
      };
      wantedBy = [ "default.target" ];
    };

    systemd.user.services."mbsync" = {
      enable = true;
      description = "mbsync service, sync all mail";
      unitConfig = {
        ConditionPathExists="%h/.mbsyncrc";
        Documentation="man:mbsync(1)";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.isync}/bin/mbsync -c %h/.mbsyncrc --all";
      };
    };

    # systemd.user.services.offlineimap = {
    #   enable = true;
    #   description = "Offlineimap: a software to dispose your mailbox(es) as a local Maildir(s)";
    #   serviceConfig = {
    #     Type      = "oneshot";
    #     ExecStart = "${cfg.package}/bin/offlineimap -u syslog -o";
    #     # 14 minutes for REALLY long syncs when I archive a bunch of mail
    #     # this makes sense because it's going to run again a minute after this
    #     # and it takes about a minute for it to "shutdown" cleanly
    #     TimeoutStartSec = "840sec";
    #   };
    #   path = with pkgs; [ imapfilter ];
    # };
    # systemd.user.timers.offlineimap = {
    #   enable = true;
    #   description = "offlineimap timer";
    #   timerConfig               = {
    #     Unit = "offlineimap.service";
    #     OnCalendar = "*:0/15";
    #     # start immediately after computer is started:
    #     Persistent = "true";
    #   };
    #   wantedBy = [ "default.target" ];
    # };
  };
}
