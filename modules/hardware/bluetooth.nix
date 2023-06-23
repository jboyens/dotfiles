{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  hwCfg = config.modules.hardware;
  cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth = {enable = lib.my.mkBoolOpt false;};

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
        settings = {
          General.Enable = "Source,Sink,Media,Socket";
        };
      };
    })

    (mkIf (cfg.enable
      && (config.services.xserver.enable
        || config.modules.desktop.swaywm.enable)) {
      services.blueman.enable = true;
    })
  ];
}
