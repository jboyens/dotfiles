# modules/dev/clojure.nix --- https://clojure.org/
#
# I don't use clojure... yet.
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
  cfg = devCfg.clojure;
in {
  options.modules.dev.clojure = {
    enable = lib.my.mkBoolOpt false;
    xdg.enable = lib.my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        clojure
        joker
        leiningen
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
