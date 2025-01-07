{
  inputs,
  lib,
  ezModules,
  ...
}: {
  imports = lib.attrValues {
    inherit
      (ezModules)
      emacs
      everything
      git
      gpg
      secrets
      script-directory
      tmux
      zsh
      ;
  };
  _module.args = {inherit inputs;};

  home = {
    username = lib.mkForce "jboyens";
    homeDirectory = lib.mkForce "/home/jboyens";

    stateVersion = "24.11";
  };
}
