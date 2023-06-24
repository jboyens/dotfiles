{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    brightnessctl
    playerctl
    polkit_gnome
    unstable.ydotool
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

  programs.thunar.plugins = with nixpkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with nixpkgs; [
      ubuntu_font_family
      dejavu_fonts
      symbola
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      cascadia-code
      atkinson-hyperlegible
      inconsolata
      curie
      scientifica
      ttf-envy-code-r
      fira
      fira-code
      fira-mono
      iosevka-bin
      (iosevka-bin.override {variant = "sgr-iosevka-term";})
      _3270font
      jetbrains-mono
      hack-font
      ibm-plex
      oxygenfonts
      (nerdfonts.override {fonts = ["FiraCode" "FiraMono"];})
    ];
  };

  # Try really hard to get QT to respect my GTK theme.
  # home.sessionVariables.GTK_DATA_PREFIX = ["${config.system.path}"];
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";
  home.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";

  # Clean up leftovers, as much as we can
  system.userActivationScripts.cleanupHome = ''
    pushd "/home/jboyens"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';
}
