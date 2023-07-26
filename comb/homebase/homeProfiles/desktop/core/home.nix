{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  # Try really hard to get QT to respect my GTK theme.
  # sessionVariables.GTK_DATA_PREFIX = ["${config.system.path}"];
  sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";
  sessionVariables.QT_STYLE_OVERRIDE = "kvantum";

  packages = with nixpkgs; [
    brightnessctl
    playerctl
    polkit_gnome
    ydotool
    libqalculate # calculator cli w/ currency conversion
    (makeDesktopItem {
      name = "scratch-calc";
      desktopName = "Calculator";
      icon = "calc";
      exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
      categories = ["Development"];
    })
    xfce.thunar
    qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
    libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
    xdg-utils
    paper-icon-theme
  ];
}
