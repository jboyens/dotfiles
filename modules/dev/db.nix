# modules/dev/db.nix
#
# Packages for various cloud services
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev.db;
in {
  options.modules.dev.db = {
    postgres.enable = lib.my.mkBoolOpt false;
    mysql.enable = lib.my.mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.postgres.enable {
      user.packages = with pkgs; [postgresql pgcenter];
    })

    (mkIf cfg.mysql.enable {
      user.packages = with pkgs; [mysql];
    })
  ];
}
