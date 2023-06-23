{
  config,
  options,
  lib,
  pkgs,
  my,
  ...
}:
with lib; let
  devCfg = config.modules.dev;
  cfg = devCfg.scala;
in {
  options.modules.dev.scala = {
    enable = lib.my.mkBoolOpt false;
    xdg.enable = lib.my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        scala
        jdk
        sbt
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
