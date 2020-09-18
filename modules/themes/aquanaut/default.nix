# themes/aquanaut/default.nix --- a sea-blue linux theme

{ config, options, lib, pkgs, ... }:
with lib;
let cfg = config.modules;
in {
  options.modules.themes.aquanaut = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.themes.aquanaut.enable {
    modules.theme = {
      name = "Aquanaut";
      version = "0.1";
      path = ./.;

      wallpaper = {
        path = "${config.modules.theme.path}/wallpaper.jpg";
      };
    };

    services.picom = {
      activeOpacity = "0.96";
      inactiveOpacity = "0.75";
      settings = {
        blur-background = true;
        blur-background-frame = true;
        blur-background-fixed = true;
        blur-kern = "7x7box";
        blur-strength = 340;
      };
    };

    services.xserver.displayManager.lightdm = {
      greeters.mini.extraConfig = ''
        text-color = "#bbc2cf"
        password-background-color = "#29323d"
        window-color = "#0b1117"
        border-color = "#0b1117"
      '';
    };

    fonts.fonts = [ pkgs.nerdfonts ];
    my.packages = with pkgs; [
      nordic
      paper-icon-theme # for rofi
      gnome3.defaultIconTheme
    ];
    my.zsh.rc = lib.readFile ./zsh/prompt.zsh;

    my.home = {
      home.file = mkMerge [
        (mkIf cfg.desktop.browsers.firefox.enable {
          ".mozilla/firefox/${cfg.desktop.browsers.firefox.profileName}.default/chrome/userChrome.css" =
            {
              source = ./firefox/userChrome.css;
            };
        })
      ];

      xdg.configFile = mkMerge [
        (mkIf (config.services.xserver.enable || cfg.desktop.swaywm.enable) {
          "xtheme/90-theme".source = ./Xresources;
          # GTK
          "gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=Nordic-bluish-accent
            gtk-icon-theme-name=Paper
            gtk-fallback-icon-theme=gnome
            gtk-application-prefer-dark-theme=true
            gtk-cursor-theme-name=Paper
            gtk-xft-hinting=1
            gtk-xft-hintstyle=hintfull
            gtk-xft-rgba=none
          '';
          # GTK2 global theme (widget and icon theme)
          "gtk-2.0/gtkrc".text = ''
            gtk-theme-name="Nordic-bluish-accent"
            gtk-icon-theme-name="Paper-Mono-Dark"
            gtk-font-name="Sans 10"
          '';
          # QT4/5 global theme
          "Trolltech.conf".text = ''
            [Qt]
            style=Nordic-bluish-accent
          '';
        })
        (mkIf cfg.desktop.bspwm.enable {
          "bspwm/rc.d/polybar".source = ./polybar/run.sh;
          "bspwm/rc.d/theme".source = ./bspwmrc;
        })
        (mkIf cfg.desktop.swaywm.enable {
          "sway/rc.d/swaytheme".source = ./swaytheme;
          "waybar".source = ./waybar;
          "alacritty".source = ./alacritty;
        })
        (mkIf cfg.desktop.apps.rofi.enable {
          "rofi/theme" = {
            source = ./rofi;
            recursive = true;
          };
        })
        (mkIf (cfg.desktop.bspwm.enable) { # || cfg.desktop.swaywm.enable) {
          "polybar" = {
            source = ./polybar;
            recursive = true;
          };
          "dunst/dunstrc".source = ./dunstrc;
        })
        (mkIf cfg.shell.tmux.enable { "tmux/theme".source = ./tmux.conf; })
      ];
    };
  };
}
