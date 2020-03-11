# modules/cloud.nix

{ pkgs, ... }:
{
  my.packages = with pkgs; [
    azure-cli
    awscli
  ];
}
