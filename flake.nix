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

  inputs =
    {
      # Core dependencies.
      nixpkgs.url = "nixpkgs/nixos-unstable";     # primary nixpkgs
      nixpkgs-unstable.url = "nixpkgs/master";    # for packages on the edge

      home-manager.url = "github:nix-community/home-manager/master";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixpkgs";

      # Extras
      emacs-overlay.url  = "github:nix-community/emacs-overlay";
      emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
      nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

      stylix.url = "github:danth/stylix";
      stylix.inputs.nixpkgs.follows = "nixpkgs";
      stylix.inputs.home-manager.follows = "home-manager";
      stylix.inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

      base16-schemes = {
        url = github:base16-project/base16-schemes;
        flake = false;
      };

      # jboyens.url = "github:jboyens/nixpkgs?rev=39c8f7fb882f642cbf11429f5dff210e08f6b205";
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [
        self.overlay
        inputs.emacs-overlay.overlay
        inputs.nixpkgs-wayland.overlay
      ];
      pkgs' = mkPkgs nixpkgs-unstable [
        self.overlay
        inputs.emacs-overlay.overlay
        inputs.nixpkgs-wayland.overlay
      ];

      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in {
      lib = lib.my;

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };

      overlays =
        (mapModules ./overlays import);

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts {};

      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
      } // import ./templates;
      defaultTemplate = self.templates.full;

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };
    };
}
