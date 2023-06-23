{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev;
in {
  options.modules.dev = {
    xdg.enable = lib.my.mkBoolOpt true;
  };

  config = mkIf cfg.xdg.enable {
    # TODO
  };
}
