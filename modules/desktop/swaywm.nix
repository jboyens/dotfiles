{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.swaywm;
  waybar = inputs.nixpkgs.legacyPackages.x86_64-linux.waybar;
in {
  options.modules.desktop.swaywm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
#
    # assumes user id of 1000
    modules.theme.onReload.swaywm = ''
      ${pkgs.sway}/bin/swaymsg reload
    '';

    environment.systemPackages = with pkgs; [
      waybar
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
      autotiling
      # wlay
      wlr-randr
      brightnessctl
      wev
      polkit_gnome
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      gnome3.adwaita-icon-theme
      gnome3.defaultIconTheme
      flashfocus
      polkit_gnome
      i3status-rust
    ];

    services = {
      redshift.enable = true;
      redshift.package = pkgs.redshift-wlr;

      xserver.enable = false;
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

        export XDG_CURRENT_DESKTOP=sway

        export WLR_DRM_NO_MODIFIERS=1
      '';
      wrapperFeatures = {
        gtk = true;
        base = true;
      };
    };
    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.autotiling = {
      description = "Sway autotiling";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.autotiling}/bin/autotiling";
        RestartSec = 5;
        Restart = "always";
      };
    };

    systemd.user.services.mako = {
      description = "Mako notifications";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mako}/bin/mako";
        RestartSec = 5;
        Restart = "always";
      };
    };

    # systemd.user.services.waybar = {
    #   description = "Waybar";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = "${waybar}/bin/waybar";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    # systemd.user.services.gnome-polkit = {
    #   description = "GNOME Polkit";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    systemd.user.services.swayidle = {
      description = "Sway idle";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 'swaylock -f -c 000000' \
            timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep 'swaylock -f -c 000000'
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sway" = {
        source = "${configDir}/sway";
        recursive = true;
      };

      # "mako" = {
      #   source = "${configDir}/mako";
      #   recursive = true;
      # };
    };
  };
}
