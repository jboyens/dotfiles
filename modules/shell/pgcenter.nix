{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.shell.pgcenter = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.pgcenter.enable {
    my = { packages = with pkgs; [ unstable.pgcenter ]; };
  };
}
