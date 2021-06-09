# modules/desktop/term/foot.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.foot;
in {
  options.modules.desktop.term.foot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = foot ] && export TERM=xterm-256color
    '';

    home.configFile."foot" = {
      source = "${config.dotfiles.configDir}/foot";
      recursive = true;
    };

    user.packages = with pkgs; [
      unstable.foot
    ];
  };
}
