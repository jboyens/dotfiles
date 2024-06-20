{
  inputs,
  cell,
}: let
  inherit (cell) pkgs lib;
in
  lib.mapAttrs (_: inputs.std.lib.dev.mkShell) {
    default = _: {
      name = "Steve";

      imports = [inputs.std.std.devshellProfiles.default];

      packages = with pkgs; [
        statix
        # nil
        nixfmt-rfc-style
        nixpkgs-fmt
        alejandra
      ];

      commands = [
        {
          package = inputs.hive.inputs.colmena.packages.x86_64-linux.colmena;
        }
        # {package = inputs.namaka.packages.default;}
        {
          category = "general commands";
          name = "fmt";
          help = "Format repository";
          command = "nix fmt $PRJ_ROOT";
        }
        # (lib.mkIf stdenv.isLinux {
        #   package = nixos-generators.packages.nixos-generate;
        #   category = "generate";
        # })
        {
          category = "nix";
          name = "switch";
          help = "Switch configurations";
          command = "sudo nixos-rebuild switch --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "boot";
          help = "Switch boot configuration";
          command = "sudo nixos-rebuild boot --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "dotest";
          help = "Test configuration";
          command = "sudo nixos-rebuild test --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "update";
          help = "Update inputs";
          command = "nix flake update --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "check";
          help = "Check flake";
          command = "nix flake check $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "dry-build";
          help = "Dry-build the flake";
          command = "sudo nixos-rebuild dry-build --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "build";
          help = "Build the flake";
          command = "sudo nixos-rebuild build --flake $PRJ_ROOT $@";
        }
        {
          category = "nix";
          name = "clean";
          help = "Clean result/ dirs";
          command = "(cd $PRJ_ROOT && fd --type symlink -u result -X rm {})";
        }

        {
          category = "packages";
          name = "update-packages";
          help = "Update packages in this repo";
          command = "(cd $PRJ_ROOT/comb/common/packages && nix shell github:berberman/nvfetcher/0.6.2 --command nvfetcher -c sources.toml -k ~/keyfile.toml)";
        }
      ];
    };
  }
