{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.teamviewer;
in {
  options.modules.services.teamviewer = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.teamviewer.enable = true;
  };
}
