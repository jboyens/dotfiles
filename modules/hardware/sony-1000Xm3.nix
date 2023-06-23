{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.sony-1000Xm3;
in {
  options.modules.hardware.sony-1000Xm3 = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = [
      # pkgs.my.sony-headphones-client
    ];
  };
}
