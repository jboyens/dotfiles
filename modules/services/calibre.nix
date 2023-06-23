{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.calibre;
in {
  options.modules.services.calibre = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.calibre-server.enable = true;

    networking.firewall.allowedTCPPorts = [8080];
  };
}
