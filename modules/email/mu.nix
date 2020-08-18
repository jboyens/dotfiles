{ config, options, lib, pkgs, ... }:

with lib; {
  options.modules.email.mu = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.email.mu.enable {
    my = {
      packages = with pkgs; [
        unstable.mu
        unstable.offlineimap
        unstable.imapfilter
      ];
    };
  };
}
