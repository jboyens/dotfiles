{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.maestral;
in {
  options.modules.desktop.apps.maestral = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      maestral
      maestral-gui
    ];

    systemd.user.services."maestral-daemon@maestral" = {
      description = "Maestral daemon for the config %i";
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.maestral}/bin/maestral start -f -c %i";
        ExecStop = "${pkgs.maestral}/bin/maestral stop";
        WatchdogSec = 30;
      };
    };

    # systemd.user.services.maestral = {
    #   description = "Maestral Dropbox Client";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };
  };
}
