{ config, options, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./common.nix
  ];

  options.modules.desktop.swaywm = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.swaywm.enable {
    environment.systemPackages = with pkgs; [
      (waybar.override { pulseSupport = true; })
      wofi
      mako
      kanshi
      wob
      # current version of i3ipc in 20.03 is too old
      my.autotiling
    ];

    services = {
      picom.enable = false;
      redshift.enable = true;
      redshift.package = pkgs.redshift-wlr;
    };

    programs.sway.enable = true;

    # link recursively so other modules can link files in their folders
    my.home.xdg.configFile = {
      "sway" = {
        source = <config/sway>;
        recursive = true;
      };
    };
  };
}
