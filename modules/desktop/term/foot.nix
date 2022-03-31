# modules/desktop/term/foot.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term.foot;
  colorscheme = config.modules.theme.colorscheme;
in {
  options.modules.desktop.term.foot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = foot ] && export TERM=xterm-256color
    '';

    home-manager.users.${config.user.name}.programs = {
      foot.enable = true;
      foot.settings = {
        main = {
          font="Iosevka Term";
          pad="10x10";
        };
        cursor.color = "${colorscheme.colors.base00} ${colorscheme.colors.base05}";
        colors = {
          alpha = 1.0;
          background = "${colorscheme.colors.base00}";
          foreground = "${colorscheme.colors.base05}";
          regular0 = "${colorscheme.colors.base00}";
          regular1 = "${colorscheme.colors.base08}";
          regular2 = "${colorscheme.colors.base0B}";
          regular3 = "${colorscheme.colors.base0A}";
          regular4 = "${colorscheme.colors.base0D}";
          regular5 = "${colorscheme.colors.base0E}";
          regular6 = "${colorscheme.colors.base0C}";
          regular7 = "${colorscheme.colors.base05}";
          bright0 = "${colorscheme.colors.base03}";
          bright1 = "${colorscheme.colors.base09}";
          bright2 = "${colorscheme.colors.base01}";
          bright3 = "${colorscheme.colors.base02}";
          bright4 = "${colorscheme.colors.base04}";
          bright5 = "${colorscheme.colors.base06}";
          bright6 = "${colorscheme.colors.base0F}";
          bright7 = "${colorscheme.colors.base07}";
        };
        key-bindings = {
          clipboard-copy = "Control+Shift+c";
          clipboard-paste = "Control+Shift+v";
        };
      };
    };


    user.packages = with pkgs; [
      unstable.foot
    ];
  };
}
