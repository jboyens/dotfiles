{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in rec {
  base = with homeProfiles; [
    shell.zsh
    shell.git
    shell.gnupg
    shell.docker
    shell.tmux
    shell.utils
    keyboard
    email
  ];

  laptop = with homeProfiles; [];

  development = with homeProfiles; [
    # dev.cc
    # dev.clojure
    # dev.cloud.amazon
    dev.cloud.generic
    dev.cloud.google
    # dev.cloud.microsoft
    # dev.common-lisp
    # dev.db.mysql
    dev.db.postgres
    dev.go
    # dev.lua
    # dev.node
    # dev.python
    dev.ruby
    # dev.rust
    # dev.scala
    dev.shell
  ];

  text = with homeProfiles; [editors.vim editors.emacs];

  graphical = with homeProfiles; [
    desktop.core
    desktop.apps.bitwarden
    desktop.apps.element-desktop
    desktop.apps.maestral
    desktop.apps.rofi
    desktop.apps.signal-desktop
    desktop.apps.slack
    desktop.apps.zoom
    desktop.browsers.brave
    desktop.browsers.chrome
    desktop.browsers.firefox
    # desktop.browsers.qutebrowser
    # desktop.i3
    desktop.media.documents
    desktop.media.mpv
    desktop.media.spotify
    desktop.swaywm
    # desktop.term.alacritty
    desktop.term.foot
    # desktop.term.st
  ];

  jboyens = music ++ graphical ++ base ++ (with homeProfiles; [editors.emacs editors.vim dev.cloud.google dev.cloud.generic]);

  nixos = base;

  music = with homeProfiles; [audio];

  hyprland = with homeProfiles; [];

  xmonad = with homeProfiles; [];
}
