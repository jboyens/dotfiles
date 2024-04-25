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
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        std.inputs.devshell.url = "github:numtide/devshell";
      };
    };

    std.inputs.devshell.url = "github:numtide/devshell";
    hive.inputs.colmena.url = "github:zhaofengli/colmena";

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

    stylix = {
      # url = "github:danth/stylix";
      url = "github:danth/stylix/4da2d793e586f3f45a54fb9755ee9bf39d3cd52e";
      # url = "github:danth/stylix/release-23.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        base16.follows = "base16";
        home-manager.follows = "home-manager";
      };
    };

    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
  };

  outputs = {
    self,
    hive,
    std,
    ...
  } @ inputs: let
    # lib = inputs.nixpkgs.lib // builtins;
    collect = hive.collect // {renamer = cell: target: "${target}";};
  in
    hive.growOn {
      inherit inputs;

      cellsFrom = ./comb;

      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        # library
        (functions "lib")

        # modules
        (functions "nixosModules")
        (functions "homeModules")

        # profiles
        (functions "hardwareProfiles")
        (functions "nixosProfiles")
        (functions "homeProfiles")

        # suites
        (functions "nixosSuites")
        (functions "homeSuites")

        # configurations
        nixosConfigurations
        homeConfigurations
        diskoConfigurations
        colmenaConfigurations

        (installables "generators")
        (installables "packages")

        # pkgs
        (pkgs "pkgs")

        # devshells
        (devshells "devshells")
      ];

      nixpkgsConfig = {
        allowUnfreePredicate = pkg: true;
        allowUnfree = true;
        permittedInsecurePackages = [];
      };
    } {
      lib = std.pick self ["common" "lib"];
      devShells = std.harvest self ["common" "devshells"];
      packages =
        std.harvest self [["common" "generators"] ["common" "packages"]];
      pkgs = std.harvest self [["common" "pkgs"]];

      nixosConfigurations = collect self "nixosConfigurations";

      nixosProfiles = {
        common = std.harvest self [["common" "nixosProfiles"]];
        laptop = std.harvest self [["laptop" "nixosProfiles"]];
        server = std.harvest self [["server" "nixosProfiles"]];
      };

      nixosModules = std.harvest self [["server" "nixosModules"]];

      homeConfigurations = collect self "homeConfigurations";

      homeProfiles = std.harvest self [
        ["common" "homeProfiles"]
        ["laptop" "homeProfiles"]
        ["server" "homeProfiles"]
      ];

      colmenaHive = collect self "colmenaConfigurations";

      microvms = std.harvest self [["common" "microvms"]];
    };
}
