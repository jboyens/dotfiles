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
      mu
      imapfilter
      unstable.isync
    ];

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
