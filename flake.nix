# Author:  JR Boyens w/ original inspiration from Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/jboyens/dotfiles
# License: MIT
{
  description = "An unexpectedly complicated nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    # nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/master";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/master";
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    lib-aggregate.url = "github:nix-community/lib-aggregate";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    base16.url = "github:SenchoPens/base16.nix";
    base16-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    devshell.url = "github:numtide/devshell";

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      # url = "github:danth/stylix/4da2d793e586f3f45a54fb9755ee9bf39d3cd52e";
      # url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        base16.follows = "base16";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    # lix-module,
    flake-parts,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.ez-configs.flakeModule
      ];

      debug = true;

      systems = ["x86_64-linux"];

      perSystem = {
        system,
        lib,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        _module.args = {inherit pkgs;};
        devshells.default = {pkgs, ...}: {
          packages = lib.attrValues {
            inherit
              (pkgs)
              alejandra
              statix
              vulnix
              deadnix
              colmena
              nix-update
              ;

            # lix = lix-module.packages."${system}".default;
          };

          commands = [
            {
              help = "format nix files";
              name = "fmt";
              category = "formatter";
              command = "nix fmt .";
            }
            {
              help = "switch to new version now";
              category = "NixOS";
              name = "switch";
              command = "${lib.getExe pkgs.nh} os switch";
            }
            {
              help = "switch to new version on boot";
              category = "NixOS";
              name = "boot";
              command = "${lib.getExe pkgs.nh} os boot";
            }
            {
              help = "test new version";
              category = "NixOS";
              name = "test";
              command = "${lib.getExe pkgs.nh} os test";
            }
            {
              help = "update flake";
              category = "NixOS";
              name = "update";
              command = "nix flake update";
            }
            {
              help = "check flake";
              category = "NixOS";
              name = "check";
              command = "nix flake check";
            }
            {
              help = "dry build";
              category = "NixOS";
              name = "dry-build";
              command = "${lib.getExe pkgs.nh} os build --dry";
            }
            {
              help = "build";
              category = "NixOS";
              name = "build";
              command = "${lib.getExe pkgs.nh} os build";
            }
            {
              help = "update packages";
              name = "update-packages";
              command = "update.sh";
            }
          ];
        };

        packages = import ./packages {
          inherit inputs pkgs lib;
        };

        formatter = pkgs.alejandra;
      };

      ezConfigs = {
        root = ./.;
        globalArgs = {inherit inputs self;};
        nixos.hosts.bishop.userHomeModules = ["jboyens"];
        nixos.hosts.mechagodzilla.userHomeModules = ["jboyens"];
        nixos.hosts.tinman.userHomeModules = ["server"];
        home.users.jboyens.importDefault = true;
      };

      flake = {};
    };

  # nixpkgsConfig = {
  #   allowUnfreePredicate = pkg: true;
  #   allowUnfree = true;
  #   permittedInsecurePackages = [];
  # };
}
