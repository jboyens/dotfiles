# Author:  JR Boyens w/ original inspiration from Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/jboyens/dotfiles
# License: MIT
{
  description = "An unexpectedly complicated nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/master";
    # nixpkgs.url = "nixpkgs/master";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixpkgs-wayland = {
      # url = "github:nix-community/nixpkgs-wayland/1ce086a5ec78554848ab094cc135eb6c26839642";
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16.url = "github:SenchoPens/base16.nix";
    base16-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    catppuccin-base16 = {
      url = "github:catppuccin/base16";
      flake = false;
    };

    base16-rofi = {
      url = "github:tinted-theming/base16-rofi";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/base16";
      flake = false;
    };

    devenv.url = "github:cachix/devenv";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
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
      # url = "github:danth/stylix/release-23.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        base16.follows = "base16";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    self,
    lix-module,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        inputs.ez-configs.flakeModule
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        system,
        lib,
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      in {
        _module.args = {inherit pkgs;};
        devenv.shells.default = {pkgs, ...}: {
          packages = lib.attrValues {
            inherit (pkgs) alejandra statix cachix vulnix deadnix;

            lix = lix-module.packages."${system}".default;
          };
          # languages.nix.enable = true;

          scripts = {
            fmt.exec = "nix fmt .";
            switch.exec = "nh os switch";
            boot.exec = "nh os boot";
            update.exec = "nix flake update";
            check.exec = "nix flake check --impure";
            dry-build.exec = "nh os build --dry";
            build.exec = "nh os build";
            update-packages.exec = "(cd packages && nix shell github:berberman/nvfetcher/0.6.2 --command nvfetcher -c sources.toml -k ~/keyfile.toml)";
          };
        };

        packages = import ./packages {
          inherit inputs pkgs lib;
        };
      };

      ezConfigs = {
        root = ./.;
        globalArgs = {inherit inputs self;};
        nixos.hosts.bishop.userHomeModules = ["jboyens"];
        home.users.jboyens.importDefault = true;
      };

      flake = {
      };
    };

  # nixpkgsConfig = {
  #   allowUnfreePredicate = pkg: true;
  #   allowUnfree = true;
  #   permittedInsecurePackages = [];
  # };
}
