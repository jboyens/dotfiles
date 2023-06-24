{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [maestral maestral-gui];

  systemd.user.services."maestral-daemon@maestral" = {
    Unit = {Description = "Maestral daemon for the config %i";};

    Service = {
      Type = "notify";
      ExecStart = "${nixpkgs.maestral}/bin/maestral start -f -c %i";
      ExecStop = "${nixpkgs.maestral}/bin/maestral stop";
      WatchdogSec = "30s";
    };

    Install = {WantedBy = ["default.target"];};
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
}
