# modules/backup/restic.nix

{ pkgs, ... }: {
  my = { packages = with pkgs; [ restic ]; };
}
