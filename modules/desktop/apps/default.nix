{ config, lib, pkgs, ... }:

{
  imports = [
    ./daw.nix
    ./discord.nix
    ./slack.nix
    ./graphics.nix
    ./recording.nix
    ./rofi.nix
    ./skype.nix
    ./vm.nix
  ];
}
