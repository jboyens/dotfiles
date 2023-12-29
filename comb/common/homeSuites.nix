{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  jboyens-basic = [
    homeProfiles.git
    homeProfiles.zsh
    homeProfiles.emacs
    homeProfiles.tmux
    homeProfiles.devenv
    homeProfiles.gpg
    homeProfiles.script-directory
  ];

  jboyens =
    [
      homeProfiles.everything
      homeProfiles.kanshi
      homeProfiles.mako
      homeProfiles.swaywm
      homeProfiles.swaywm-bars
      homeProfiles.swaywm-keybindings
      homeProfiles.swaywm-window-commands
      homeProfiles.swayidle
      homeProfiles.swaylock
      homeProfiles.firefox-webapp
      homeProfiles.firefox
      homeProfiles.mail
      homeProfiles.hyprland
      homeProfiles.foot
      homeProfiles.wlsunset
      homeProfiles.rofi
      homeProfiles.gtk
    ]
    ++ jboyens-basic;
}
