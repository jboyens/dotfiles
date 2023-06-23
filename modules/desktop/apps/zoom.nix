{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.apps.zoom;
in {
  options.modules.desktop.apps.zoom = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.zoom-us
      # pulseaudio
    ];
  };
}
