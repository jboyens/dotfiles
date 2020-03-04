{ config, lib, pkgs, ... }:

{
  my = {
    packages = with pkgs; [
      hdparm
      bwm_ng
    ];
  };
}
