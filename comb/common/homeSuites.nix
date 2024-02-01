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
      inputs.spicetify-nix.homeManagerModule
      homeProfiles.spicetify
      homeProfiles.everything
      homeProfiles.kanshi
      homeProfiles.mako
      homeProfiles.swaywm
      homeProfiles.i3status-rust
      homeProfiles.swaywm-keybindings
      homeProfiles.firefox-webapp
      homeProfiles.firefox
      homeProfiles.mail
      homeProfiles.foot
      homeProfiles.rofi
      homeProfiles.gtk
    ]
    ++ jboyens-basic;
}
