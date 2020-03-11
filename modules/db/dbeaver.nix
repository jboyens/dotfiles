# modules/dbeaver.nix

{ pkgs, ... }:
{
  my.packages = with pkgs; [
    #unstable.dbeaver-ce
  ];
}
