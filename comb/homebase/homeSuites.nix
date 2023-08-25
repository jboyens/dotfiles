{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in {
  jboyens = [
    homeProfiles.everything
    homeProfiles.kanshi
    homeProfiles.mako
    homeProfiles.swaywm
    homeProfiles.swaywm-bars
    homeProfiles.swaywm-colors
    homeProfiles.swaywm-keybindings
    homeProfiles.swaywm-window-commands
    homeProfiles.swayidle
    homeProfiles.swaylock
    homeProfiles.firefox
    homeProfiles.mail
    homeProfiles.git
    homeProfiles.zsh
    homeProfiles.emacs
    homeProfiles.tmux
    homeProfiles.hyprland
  ];
}
