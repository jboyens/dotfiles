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
      devenv
      emacs
      everything
      firefox
      fnott
      foot
      git
      gpg
      gtk
      # hyprland
      kanshi
      mail
      # mako
      pizauth
      rofi
      secrets
      script-directory
      styling
      sway
      swaywm-keybindings
      tmux
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
