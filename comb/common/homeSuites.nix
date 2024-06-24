{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  shell = [
    homeProfiles.zsh
    homeProfiles.script-directory
    homeProfiles.gpg
  ];

  mail = [
    homeProfiles.mail
    homeProfiles.pizauth
  ];

  hyprland =
    [
      homeProfiles.hyprland
    ]
    ++ _graphical;

  sway =
    [
      homeProfiles.kanshi
      homeProfiles.swaywm
      homeProfiles.i3status-rust
      homeProfiles.swaywm-keybindings
    ]
    ++ _graphical;

  _graphical = [
    homeProfiles.wayland
    # homeProfiles.mako
    homeProfiles.fnott
    homeProfiles.eww
    homeProfiles.gtk
    homeProfiles.firefox-webapp
    homeProfiles.firefox
    homeProfiles.foot
    homeProfiles.rofi
  ];

  development = [
    homeProfiles.git
    homeProfiles.emacs
    homeProfiles.tmux
    homeProfiles.devenv
  ];

  basic = shell;

  primary =
    [homeProfiles.everything]
    ++ basic
    ++ mail
    ++ hyprland
    ++ development;

  secondary =
    [homeProfiles.everything]
    ++ basic
    ++ development;
}
