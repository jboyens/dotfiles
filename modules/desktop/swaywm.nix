{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.swaywm;
in {
  options.modules.desktop.swaywm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

    # assumes user id of 1000
    modules.theme.onReload.swaywm = ''
      ${pkgs.sway}/bin/swaymsg -s /run/user/1000/sway-ipc.1000.$(pgrep -x sway).sock reload
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
      '';
      wrapperFeatures = {
        gtk = true;
        base = true;
      };
    };

    # systemd.user.services."dunst" = {
    #   enable = true;
    #   description = "";
    #   wantedBy = [ "default.target" ];
    #   serviceConfig.Restart = "always";
    #   serviceConfig.RestartSec = 2;
    #   serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    # };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sway" = {
        source = "${configDir}/sway";
        recursive = true;
      };
    };
  };
}
