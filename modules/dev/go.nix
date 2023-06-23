# modules/dev/go.nix
{
  config,
  options,
  lib,
  pkgs,
  my,
  ...
}:
with lib; let
  cfg = config.modules.dev.go;
in {
  options.modules.dev.go = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      go
      gopls
      gocode
      gore
      gotools
      gotests
      gomodifytags
      golangci-lint
      delve
    ];
  };
}
