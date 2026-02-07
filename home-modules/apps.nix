{
  pkgs,
  lib,
  ...
}: {
  xdg.portal.xdgOpenUsePortal = true;

  home.packages = with pkgs; [
    evince
    zathura

    mpv
    mpvc

    spotify

    signal-desktop
    slack
    # zoom-us
    discord

    brightnessctl
    playerctl

    ydotool

    # polkit_gnome

    thunar

    # qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
    # kdePackages.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
    paper-icon-theme

    xdg-utils

    rofi-bluetooth
    rofi-power-menu
    rofi-pulse-select
    rofi-rbw
    rofi-systemd

    # Fake rofi dmenu entries
    (makeDesktopItem {
      name = "rofi-browsermenu";
      desktopName = "Open Bookmark in Browser";
      icon = "bookmark-new-symbolic";
      exec = "\\$DOTFILES_BIN/rofi/browsermenu";
    })

    (makeDesktopItem {
      name = "rofi-browsermenu-history";
      desktopName = "Open Browser History";
      icon = "accessories-clock";
      exec = "\\$DOTFILES_BIN/rofi/browsermenu history";
    })

    (makeDesktopItem {
      name = "rofi-filemenu";
      desktopName = "Open Directory in Terminal";
      icon = "folder";
      exec = "\\$DOTFILES_BIN/rofi/filemenu";
    })

    (makeDesktopItem {
      name = "rofi-filemenu-scratch";
      desktopName = "Open Directory in Scratch Terminal";
      icon = "folder";
      exec = "\\$DOTFILES_BIN/rofi/filemenu -x";
    })

    (makeDesktopItem {
      name = "lock-display";
      desktopName = "Lock screen";
      icon = "system-lock-screen";
      exec = "\\$DOTFILES_BIN/zzz";
    })

    pavucontrol
  ];

  programs.chromium.enable = true;

  services.mpris-proxy.enable = true;
  services.tailscale-systray.enable = true;

  home.pointerCursor = {
    package = lib.mkDefault pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
