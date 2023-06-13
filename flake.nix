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

    flake-utils = { url = "github:numtide/flake-utils"; };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.url =
      "github:NixOS/nixpkgs/nixos-23.05";
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

    comma = { url = "github:nix-community/comma"; };
    comma.inputs.nixpkgs.follows = "nixpkgs";
    comma.inputs.utils.follows = "flake-utils";

    # flexe-flakes.url = "gitlab:flexe/flakes";
    flexe-flakes.url = "/home/jboyens/Workspace/flexe-flakes";
    flexe-flakes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, flexe-flakes, flake-utils, ... }:
    let
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
    in {
      # lib = lib.my;

      overlays = (mapModules ./overlays import) // {
        default = final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };
      };

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
      } // import ./templates // {
        default = self.templates.full;
      };

      apps."${system}" = {
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
}
