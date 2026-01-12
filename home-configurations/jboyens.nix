{
  inputs,
  pkgs,
  lib,
  osConfig,
  ezModules,
  ...
}: {
  imports = lib.attrValues {
    inherit
      (ezModules)
      beancount
      # devenv
      emacs
      everything
      firefox
      fnott
      foot
      fuzzel
      git
      go
      gpg
      gtk
      # hyprland
      i3status-rust
      mail
      niri
      # mako
      obs
      pizauth
      rofi
      secrets
      script-directory
      styling
      sway
      swaywm-keybindings
      tmux
      waybar
      wayland
      way-displays
      zsh
      ;
  };
  _module.args = {inherit inputs;};

  home = {
    username = osConfig.users.users.jboyens.name;
    homeDirectory = osConfig.users.users.jboyens.home;

    packages = [
      pkgs.zathura
    ];

    stateVersion = "24.11";
  };
}
