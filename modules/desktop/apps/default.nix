{ config, lib, pkgs, ... }:

{
  imports = [
    ./daw.nix
    ./dbeaver.nix
    ./discord.nix
    ./graphics.nix
    ./recording.nix
    ./rofi.nix
    ./skype.nix
    ./slack.nix
    ./vm.nix
    ./zoom-us.nix
  ];
}
