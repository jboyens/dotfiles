{
  inputs,
  cell,
}: let
  inherit (inputs) std hive;
  lib = inputs.nixpkgs.lib // builtins;
  getImports = attrs:
    attrs.imports or [];
in
  rec {
    inherit std hive;

    rakeLeaves = dirPath: let
      seive = file: type:
      # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file)
        || (type == "directory");

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value = let
          path = dirPath + "/${file}";
        in
          if
            (type == "regular")
            || (type == "directory" && lib.pathExists (path + "/default.nix"))
          then path
          # recurse on directories that don't contain a `default.nix`
          else rakeLeaves path;
      };

      files = lib.filterAttrs seive (lib.readDir dirPath);
    in
      lib.filterAttrs (name: value: value != {})
      (lib.mapAttrs' collect files);

    mkNixosConfigurations' = cell: common:
      lib.mapAttrs
      (host: config: lib.recursiveUpdate config (common {inherit host config;}));

    mkNixosConfigurations = cell:
      mkNixosConfigurations' cell ({
        host,
        config,
      }: {
        imports =
          [
            cell.hardwareProfiles.${host}
            {networking.hostName = lib.mkDefault "${host}";}
          ]
          ++ getImports config;
      });

    mkColmenaConfigurations' = cell: common:
      lib.mapAttrs
      (host: config: lib.recursiveUpdate config (common {inherit host config;}));

    mkColmenaConfigurations = cell: defaults: configurations:
      mkColmenaConfigurations' cell ({
        host,
        config,
      }: {
        imports =
          [cell.nixosConfigurations.${host}]
          ++ getImports config
          ++ getImports defaults;
      }) (lib.mapAttrs (_: lib.recursiveUpdate defaults) configurations);

    load = inputs: cell: src: inputs.hive.load {inherit inputs cell src;};

    mkOpt = type: default: lib.mkOption {inherit type default;};
    mkOpt' = type: default: description: lib.mkOption {inherit type default description;};
    mkBoolOpt = default: mkOpt lib.types.bool default;
  }
  // lib
