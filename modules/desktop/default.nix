{ config, lib, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./swaywm.nix
    # ./stumpwm.nix

    ./apps
    ./term
    ./browsers
    ./gaming
  ];
}
