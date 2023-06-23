# modules/dev/android.nix
#
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.android;
in {
  options.modules.dev.android = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    user.extraGroups = ["adbusers"];
    services.udev.packages = [pkgs.android-udev-rules];
  };
}
