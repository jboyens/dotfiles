{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.dev.db = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.db.enable {
    my.packages = with pkgs; [ postgresql ];
  };
}
