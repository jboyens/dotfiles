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
      homeProfiles.hyprland
      homeProfiles.swaywm
      homeProfiles.i3status-rust
      homeProfiles.swaywm-keybindings
      homeProfiles.firefox-webapp
      homeProfiles.firefox
      homeProfiles.mail
      homeProfiles.foot
      homeProfiles.rofi
      homeProfiles.gtk
      homeProfiles.eww
    ]
    ++ jboyens-basic;
}
