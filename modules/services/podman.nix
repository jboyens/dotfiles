{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.podman;
in {
  options.modules.services.podman = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = with pkgs; [fuse-overlayfs];

    virtualisation = {podman = {enable = true;};};
  };
}
