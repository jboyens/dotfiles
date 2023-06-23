{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager = {xterm.enable = false;};

        displayManager = {defaultSession = "none+i3";};

        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [dmenu i3status i3lock];
        };
      };
    };
  };
}
