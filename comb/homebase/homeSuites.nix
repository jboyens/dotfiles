{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in {
  jboyens = [
    homeProfiles.everything
    homeProfiles.swaywm
    homeProfiles.firefox
    homeProfiles.mail
    homeProfiles.git
    homeProfiles.zsh
    homeProfiles.emacs
    homeProfiles.tmux
  ];
}
