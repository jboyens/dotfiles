# flake.nix --- the heart of my dotfiles
#
# Author:  Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/hlissner/dotfiles
# License: MIT
#
# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.
{
  description = "A grossly incandescent nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/master"; # for packages on the edge
    nixpkgs-stable.url = "nixpkgs/nixos-22.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    std.inputs.devshell.url = "github:numtide/devshell";
    std.inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils = {url = "github:numtide/flake-utils";};

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    emacs-overlay.inputs.flake-utils.follows = "flake-utils";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

    base16-schemes.url = "github:tinted-theming/base16-schemes";
    base16-schemes.flake = false;

    catppuccin.url = "github:catppuccin/base16";
    catppuccin.flake = false;

    comma = {url = "github:nix-community/comma";};
    comma.inputs.nixpkgs.follows = "nixpkgs";
    comma.inputs.utils.follows = "flake-utils";

    # flexe-flakes.url = "gitlab:flexe/flakes";
    flexe-flakes.url = "/home/jboyens/Workspace/flexe-flakes";
    flexe-flakes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flexe-flakes,
    flake-utils,
    ...
  }:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    ({
      withSystem,
      flake-parts-lib,
      ...
    }: {
      imports = [
        inputs.std.flakeModule
        # inputs.flake-parts.flakeModules.easyOverlay
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        system,
        ...
      }: let
        inherit (lib.my) mapModules;

        mkPkgs = pkgs: extraOverlays:
          import pkgs {
            inherit system;
            config.allowUnfree = true; # forgive me Stallman senpai
            overlays = extraOverlays ++ (lib.attrValues self.overlays);
          };
        pkgs = mkPkgs nixpkgs [
          self.overlays.default
          inputs.emacs-overlay.overlay
          inputs.nixpkgs-wayland.overlay
          inputs.flexe-flakes.overlays.default
        ];
        pkgs' = mkPkgs nixpkgs-unstable [
          self.overlays.default
          inputs.emacs-overlay.overlay
          inputs.nixpkgs-wayland.overlay
        ];

        lib = nixpkgs.lib.extend (self: super: {
          my = import ./lib {
            inherit pkgs inputs;
            lib = self;
          };
        });
      in {
        _module.args.pkgs = pkgs;

        packages = mapModules ./packages (p: pkgs.callPackage p {});

        devShells.default = import ./shell.nix {inherit pkgs;};

        formatter = pkgs.alejandra;

        apps = {
          default = {
            type = "app";
            program = ./bin/hey;
          };
          repl = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "repl" ''
              confnix=$(mktemp)
              echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
              trap "rm $confnix" EXIT
              nix repl $confnix
            '';
          };
        };
      };

      flake = let
        inherit (lib.my) mapModules mapModulesRec mapHosts;

        system = "x86_64-linux";

        mkPkgs = pkgs: extraOverlays:
          import pkgs {
            inherit system;
            config.allowUnfree = true; # forgive me Stallman senpai
            overlays = extraOverlays ++ (lib.attrValues self.overlays);
          };
        pkgs = mkPkgs nixpkgs [
          self.overlays.default
          inputs.emacs-overlay.overlay
          inputs.nixpkgs-wayland.overlay
          inputs.flexe-flakes.overlays.default
        ];
        pkgs' = mkPkgs nixpkgs-unstable [
          self.overlays.default
          inputs.emacs-overlay.overlay
          inputs.nixpkgs-wayland.overlay
        ];

        lib = nixpkgs.lib.extend (self: super: {
          my = import ./lib {
            inherit pkgs inputs;
            lib = self;
          };
        });

        oldModules =
          {
            dotfiles = import ./.;
          }
          // mapModulesRec ./modules import;
        stdModules = inputs.std.growOn {
          inherit inputs;

          cellsFrom = ./nix;
          cellBlocks = with inputs.std.blockTypes; [(devshells "shells" {ci.build = true;})];
        } {devShells = inputs.std.harvest self ["mycell" "shells"];};
      in {
        overlays =
          (mapModules ./overlays import)
          // {
            default = final: prev: {
              unstable = pkgs';
              my = self.packages."${system}";
            };
          };

        devShells."${system}".cell =
          stdModules."${system}".mycell.shells.default;

        nixosModules = oldModules;

        haumeaNixosModules = inputs.haumea.lib.load {
          src = ./modules;
          loader = inputs.haumea.lib.loaders.path;
        };

        # nixosConfigurations = mapHosts ./hosts {};

        nixosConfigurations = {
          kitt = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            modules =
              [
                {
                  nixpkgs.pkgs = pkgs;
                  networking.hostName = lib.mkDefault "kitt";
                }
                ({lib, ...}: {
                  system.stateVersion = "23.11";
                  boot = {
                    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
                    loader = {
                      efi.canTouchEfiVariables = lib.mkDefault true;
                      systemd-boot.configurationLimit = 10;
                      systemd-boot.enable = lib.mkDefault true;
                    };
                  };

                  # For rage encryption, all hosts need a ssh key pair
                  services.openssh.enable = true;

                  stylix.image = lib.mkDefault (pkgs.fetchurl {
                    url = "https://github.com/vctrblck/gruvbox-wallpapers/raw/main/forest-hut.png";
                    sha256 = "12rkqy81l1q9q8kr59m1fx100p74d18gkc5cpwr6y0i66czbxmh9";
                  });
                })
                ./hosts/kitt
                inputs.agenix.nixosModules.default
                inputs.home-manager.nixosModules.home-manager
                inputs.stylix.nixosModules.stylix
                inputs.nixos-hardware.nixosModules.common-cpu-intel
                inputs.nixos-hardware.nixosModules.common-pc-laptop
                inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
              ]
              ++ (lib.attrValues
                (lib.my.flattenTree (self.haumeaNixosModules)));

            specialArgs = let
              lib = nixpkgs.lib.extend (self: super: {
                my = import ./lib {
                  inherit pkgs inputs;
                  lib = self;
                };
              });
            in {inherit lib pkgs;};
          };
        };

        nixosProfiles = inputs.haumea.lib.load {
          src = ./profiles/nixos;
          loader = inputs.haumea.lib.loaders.path;
        };

        homeProfiles = inputs.haumea.lib.load {
          src = ./profiles/home;
          loader = inputs.haumea.lib.loaders.path;
        };

        nixosSuites = with self.nixosProfiles; rec {
          # base = [ core.default users shell ];
          # main = [ desktop.common networking.common ];

          # laptop = base ++ main;
        };

        homeSuites = with self.homeProfiles; rec {
          # default = [ browser ];

          # laptop = default;
        };

        templates =
          {
            full = {
              path = ./.;
              description = "A grossly incandescent nixos config";
            };
          }
          // import ./templates
          // {
            default = self.templates.full;
          };
      };
    });
}
