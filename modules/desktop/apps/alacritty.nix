{ config, lib, pkgs, ... }:

{
  my.packages = with pkgs; [
    alacritty
  ];
}
