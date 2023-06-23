{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = [pkgs.direnv];
    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';
  };
}
