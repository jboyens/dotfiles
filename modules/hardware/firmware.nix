{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  hwCfg = config.modules.hardware;
  cfg = hwCfg.firmware;
in {
  options.modules.hardware.firmware = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
    services.fwupd.extraRemotes = ["lvfs" "dell-esrt"];
  };
}
