# modules/dev/shell.nix --- http://zsh.sourceforge.net/
#
# Shell script programmers are strange beasts. Writing programs in a language
# that wasn't intended as a programming language. Alas, it is not for us mere
# mortals to question the will of the ancient ones. If they want shell programs,
# they get shell programs.
{
  config,
  options,
  lib,
  pkgs,
  my,
  ...
}:
with lib; let
  devCfg = config.modules.dev;
  cfg = devCfg.shell;
in {
  options.modules.dev.shell = {
    enable = lib.my.mkBoolOpt false;
    xdg.enable = lib.my.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {user.packages = with pkgs; [shellcheck];})

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
