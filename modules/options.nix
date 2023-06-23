{
  config,
  options,
  lib,
  ...
}:
with lib; {
  options = with types; {
    user = lib.my.mkOpt attrs {};

    dotfiles = {
      dir =
        lib.my.mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../.) [
            "/home/jboyens/.config/dotfiles"
            "/mnt/etc/dotfiles"
            "/etc/dotfiles"
          ]));
      binDir = lib.my.mkOpt path "${config.dotfiles.dir}/bin";
      configDir = lib.my.mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = lib.my.mkOpt path "${config.dotfiles.dir}/modules";
      themesDir = lib.my.mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = lib.my.mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = lib.my.mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile = lib.my.mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
      programs = lib.my.mkOpt' attrs {} "Apps to configure";
      services = lib.my.mkOpt' attrs {} "Services to configure";
      wayland = lib.my.mkOpt' attrs {} "Wayland config";
    };

    env = mkOption {
      type = attrsOf (oneOf [str path (listOf (either str path))]);
      apply = mapAttrs (n: v:
        if isList v
        then concatMapStringsSep ":" toString v
        else (toString v));
      default = {};
      description = "TODO";
    };
  };

  config = {
    user = let
      user = builtins.getEnv "USER";
      name =
        if elem user ["" "root"]
        then "jboyens"
        else user;
    in {
      inherit name;
      description = "The primary user account";
      extraGroups = ["wheel" "networkmanager" "video" "atd" "input"];
      isNormalUser = true;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
    };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.jboyens.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.jboyens.home.file
      #   home.configFile  ->  home-manager.users.jboyens.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.jboyens.home.xdg.dataFile
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          inherit (config.system) stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        wayland = mkAliasDefinitions options.home.wayland;
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let
      users = ["root" config.user.name];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];

    environment.extraInit =
      concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
