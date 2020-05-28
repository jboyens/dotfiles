{ config, lib, pkgs, ... }:

{
  imports = [
    ./calibre.nix
    ./docker.nix
    # ./gitea.nix
    # ./jellyfin.nix
    # ./keybase.nix
    # ./mpd.nix
    # ./nginx.nix
    # ./plex.nix
    ./ssh.nix
    ./syncthing.nix
    # ./transmission.nix
  ];
}
