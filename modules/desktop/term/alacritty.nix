{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.term.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.term.alacritty.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    my.zsh.rc = ''[ "$TERM" = alacritty ] && export TERM=xterm-256color'';

    my.packages = with pkgs; [
      alacritty
    ];
  };
}
