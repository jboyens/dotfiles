{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "Iosevka";
      fontSize = "12";
      # background = "${./wallpaper.png}";
    })
  ];
  services = {
    hypridle.enable = lib.mkIf config.programs.hyprland.enable true;

    # GNOME crypto services?
    dbus.packages = [pkgs.gcr];

    # Virtual filesystem support
    gvfs.enable = true;

    # Printing
    printing = {
      enable = true;
    };
    system-config-printer.enable = true;

    # D-Bus thumbnailer
    # tumbler.enable = true;
    #

    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
      wayland.enable = true;
    };

    xserver = {
      enable = true;

      displayManager.startx.enable = true;
      windowManager.i3.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
  };

  programs = {
    hyprland.enable = false;
    hyprlock.enable = false;

    niri.enable = true;

    # even though this is managed via home-manager, this sets up some pam stuff
    # that is important
    sway = {
      enable = false;

      wrapperFeatures = {
        gtk = true;
        base = true;
      };

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_WEBRENDER=1
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
        export NIXOS_OZONE_WL=1
      '';
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
