{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.email.mu4e;
in {
  options.modules.email.mu4e = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      offlineimap
      mu
      imapfilter
    ];
  };
}
