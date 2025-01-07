{
  inputs,
  pkgs,
  self,
  ...
}: let
  # inherit (cell.packages) pizauth isync-oauth2;
  inherit (pkgs.stdenv) system;
  pizauth = self.packages."${system}".pizauth;
  isync-oauth2 = self.packages."${system}".isync-oauth2;
in {
  home.packages = [
    inputs.nixpkgs-unstable.legacyPackages.${system}.mu
    pkgs.offlineimap
    pkgs.age

    pkgs.imapfilter
    pkgs.msmtp
    (pkgs.writeScriptBin "mu-reindex" ''
      if [ -f /tmp/mu4e_lock ]; then
        ${pkgs.coreutils-full}/bin/touch /tmp/mu_reindex_now
      else
        ${pkgs.mu}/bin/mu index --lazy-check
      fi
    '')

    pizauth
    isync-oauth2
  ];

  systemd.user = {
    startServices = "sd-switch";
    services = {
      "goimapnotify" = {
        Unit = {
          Description = "IMAP notifier using IDLE, golang version.";
          ConditionPathExists = "%h/.config/imapnotify/notify.yaml";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${isync-oauth2}/bin:${pkgs.mu}/bin:${pizauth}/bin:$PATH";
          ExecStart = "${pkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/notify.yaml";
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
