{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.discourse;
in {
  options.modules.services.discourse = {
    enable = lib.my.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.postgresql.package = pkgs.postgresql;

    services.discourse = {
      enable = true;
      enableACME = true;
      # plugins = with config.services.discourse.package.plugins; [
      #   discourse-akismet
      #   discourse-chat-integration
      #   discourse-checklist
      #   discourse-canned-replies
      #   discourse-github
      #   discourse-assign
      # ];
    };
  };
}
