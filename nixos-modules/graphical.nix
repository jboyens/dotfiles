{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.obs-studio

    pkgs.kdePackages.discover
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.kcharselect
    pkgs.kdePackages.kclock
    pkgs.kdePackages.kcolorchooser
    pkgs.kdePackages.kolourpaint
    pkgs.kdePackages.ksystemlog
    pkgs.kdePackages.sddm-kcm
    pkgs.kdiff3
    pkgs.kdePackages.kdesu

    pkgs.kdePackages.isoimagewriter
    pkgs.kdePackages.partitionmanager
    pkgs.hardinfo2
    pkgs.wayland-utils
    pkgs.wl-clipboard
    pkgs.vlc

    pkgs.kdePackages.elisa
    pkgs.kdePackages.kdepim-runtime
    pkgs.kdePackages.kmahjongg
    pkgs.kdePackages.kmines
    pkgs.kdePackages.konversation
    pkgs.kdePackages.kpat
    pkgs.kdePackages.ksudoku
    pkgs.kdePackages.ktorrent
  ];

  environment.plasma6.excludePackages = [ ];

  services = {
    flatpak.enable = true;

    # Printing
    printing.enable = true;
    system-config-printer.enable = true;

    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
  };

  programs = {
    _1password = {
      enable = true;
    };

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "jboyens" ];
    };

    niri.enable = false;

    # even though this is managed via home-manager, this sets up some pam stuff
    # that is important
    sway = {
      enable = false;

      wrapperFeatures = {
        gtk = true;
        base = true;
      };

      extraOptions = [
        "--unsupported-gpu"
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_WEBRENDER=0
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
        export NIXOS_OZONE_WL=1
      '';
    };

    thunar = {
      enable = false;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
