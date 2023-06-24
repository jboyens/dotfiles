{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  my = inputs.cells.homebase.packages;
  inherit (my) pizauth;
  inherit (my) isync-oauth2;
in {
  home.packages = with nixpkgs; [
    offlineimap
    # don't install mu4e here
    mu
    imapfilter
    # FIXME
    # isync-oauth2
    msmtp
    pizauth
    (writeScriptBin "mu-reindex" ''
      if [ -f /tmp/mu4e_lock ]; then
        ${coreutils-full}/bin/touch /tmp/mu_reindex_now
      else
        ${mu}/bin/mu index --lazy-check
      fi
    '')
  ];

  systemd.user = {
    startServices = "sd-switch";
    services = {
      pizauth = {
        Unit = {
          Description = "OAuth2 Service Daemon";
          ConditionPathExists = "%h/.config/pizauth.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${nixpkgs.libnotify}/bin:${nixpkgs.age}/bin:$PATH";
          ExecStart = "${pizauth}/bin/pizauth server -dvc %h/.config/pizauth.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      "goimapnotify@flexe" = {
        Unit = {
          Description = "IMAP notifier using IDLE, golang version.";
          ConditionPathExists = "%h/.config/imapnotify/%I/notify.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${isync-oauth2}/bin:${nixpkgs.mu}/bin:${pizauth}/bin:$PATH";
          ExecStart = "${nixpkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      "goimapnotify@fooninja" = {
        Unit = {
          Description = "IMAP notifier using IDLE, golang version.";
          ConditionPathExists = "%h/.config/imapnotify/%I/notify.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${isync-oauth2}/bin:${nixpkgs.mu}/bin:${pizauth}/bin:$PATH";
          ExecStart = "${nixpkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      mbsync = {
        Unit = {
          Description = "mbsync service, sync all mail";
          ConditionPathExists = "%h/.mbsyncrc";
          Documentation = "man:mbsync(1)";
        };

        Service = {
          Environment = "PATH=${pizauth}/bin:$PATH";
          Type = "oneshot";
          ExecStart = "${isync-oauth2}/bin/mbsync -c %h/.mbsyncrc --all";
        };
      };
    };

    timers = {
      mbsync = {
        Unit = {
          Description = "call mbsync on all accounts every 15 m";
          ConditionPathExists = "%h/.mbsyncrc";
        };

        Timer = {
          Unit = "mbsync.service";
          OnCalendar = "*:0/15";
          Persistent = "true";
        };

        Install = {WantedBy = ["default.target"];};
      };
    };
  };
}
