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
      gpg
      gtk
      # hyprland
      i3status-rust
      kanshi
      mail
      niri
      # mako
      pizauth
      rofi
      secrets
      script-directory
      styling
      swaywm-keybindings
      i3status-rust
      tmux
      waybar
      wayland
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
