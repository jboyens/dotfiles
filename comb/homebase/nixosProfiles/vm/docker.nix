{
  inputs,
  cell,
}: let
  inherit (cell) lib;
  inherit (inputs) nixpkgs;
in {
  environment.systemPackages = with nixpkgs; [docker docker-compose];

  environment.variables = {
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";
    DOCKER_BUILDKIT = "1";
  };

  users.users.jboyens.extraGroups = ["docker"];

  # modules.shell.zsh.rcFiles = [ "${configDir}/docker/aliases.zsh" ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = lib.mkDefault false;
      # listenOptions = [];
    };
  };
}
