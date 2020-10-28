{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.shell.utils = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.utils.enable {
    my.packages = with pkgs; [
      # for calculations
      bc

      # for watching networks
      bwm_ng

      # for guessing mime-types
      file

      # for checking out block devices
      hdparm

      # for checking in on block devices
      iotop

      # for understanding who has what open
      lsof

      # for running commands repeatedly
      unstable.entr

      # for downloading things rapidly
      axel

      # for monitoring
      unstable.bottom

      # for json parsing
      unstable.jq

      # for yaml parsing
      unstable.yq

      # for pretty du
      unstable.du-dust

      # dig
      bind

      # sound
      pavucontrol
      pamixer

      # network
      mtr
    ];
  };
}
