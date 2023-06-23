{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.media.mpv;
in {
  options.modules.desktop.media.mpv = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # mpv-with-scripts
      mpv
      mpvc # CLI controller for mpv
    ];
  };
}
