{ config, lib, pkgs, ... }:

{
  my = {
    packages = with pkgs; [
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
    ];
  };
}
