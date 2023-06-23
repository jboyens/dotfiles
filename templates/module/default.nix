{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  cfg = config.modules.X.Y;
in {
  options.modules.X.Y = {enable = lib.my.mkBoolOpt false;};

  config = cfg.enable {};
}
