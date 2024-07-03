{pkgs, ...}: let
  inherit (pkgs) pizauth;
in {
  systemd.user = {
    services = {
      pizauth = {
        Unit = {
          Description = "OAuth2 Service Daemon";
          ConditionPathExists = "%t/agenix/pizauth";
          After = "network.target agenix.service";
        };

        Service = {
          Environment = "PATH=${pkgs.libnotify}/bin:${pkgs.age}/bin:$PATH";
          ExecStart = "${pizauth}/bin/pizauth server -dvc %t/agenix/pizauth";
          ExecReload = "${pizauth}/bin/pizauth reload";
          ExecStop = "${pizauth}/bin/pizauth shutdown";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };
    };
  };
}
