{ config, lib, pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./ncmpcpp.nix
    ./pass.nix
    ./pgcenter.nix
    ./ranger.nix
    ./tmux.nix
    ./utils.nix
    ./weechat.nix
    ./zsh.nix
  ];
}
