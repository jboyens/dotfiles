{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = {
    default = lib.my.mkOpt types.str "xterm";
  };

  config = {
    services.xserver.desktopManager.xterm.enable = mkDefault (cfg.default == "xterm");

    env.TERMINAL = cfg.default;
  };
}
