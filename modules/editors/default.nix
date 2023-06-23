{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.editors;
in {
  options.modules.editors = {
    default = lib.my.mkOpt types.str "vim";
  };

  config = mkIf (cfg.default != null) {
    env.EDITOR = cfg.default;
  };
}
