{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.mpd;
in {
  options.modules.services.mpd = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = "/mnt/nas/music";
    };
  };
}
