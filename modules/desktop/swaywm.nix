{ config, options, lib, pkgs, ... }:
with lib; {
  imports = [ ./common.nix ];

  options.modules.desktop.swaywm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.swaywm.enable {
    environment.systemPackages = with pkgs; [
      (waybar.override { pulseSupport = true; })
      # waybar
      wofi
      mako
      kanshi
      wob
      qt5.qtwayland
      grim
      slurp
      unstable.sway-contrib.grimshot
      unstable.xdg-desktop-portal-wlr
      wl-clipboard
      # unstable.sway-contrib.inactive-windows-transparency
      # current version of i3ipc in 20.03 is too old
      # my.autotiling
      autotiling
    ];

    services = {
      picom.enable = false;
      redshift.enable = true;
      redshift.package = pkgs.redshift-wlr;
    };

    programs.sway = {
      enable = true;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
        # xrdb -merge "$XDG_CONFIG_HOME"/xtheme/*
      '';
      wrapperFeatures = {
        gtk = true;
        base = true;
      };
    };
    # programs.sway.package = pkgs.unstable.sway;

    # link recursively so other modules can link files in their folders
    my.home.xdg.configFile = {
      "sway" = {
        source = <config/sway>;
        recursive = true;
      };
    };
  };
}
