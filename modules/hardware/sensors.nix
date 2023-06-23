{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.sensors;
in {
  options.modules.hardware.sensors = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.lm_sensors];
  };
}
