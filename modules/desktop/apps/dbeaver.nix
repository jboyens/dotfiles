# modules/desktop/apps/dbeaver.nix

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.dbeaver = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.dbeaver.enable {
    my.packages = with pkgs; [ unstable.dbeaver ];
  };
}
