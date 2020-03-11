# modules/postgres.nix

{ pkgs, ... }:
{
  my.packages = with pkgs; [
    pgcenter
  ];
}
