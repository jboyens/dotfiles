# Author:  JR Boyens w/ original inspiration from Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/jboyens/dotfiles
# License: MIT
{
  description = "An unexpectedly complicated nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/master";

    std = {
      url = "github:divnix/std";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        nixago.follows = "nixago";
        paisano.follows = "paisano";
      };
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago.url = "github:nix-community/nixago";

    nixos-generators = {
      url = "github:nix-community/nixos-generators/1.8.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixlib.follows = "nixpkgs";
      };
    };

    paisano = {
      url = "github:divnix/paisano";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hive = {
      url = "github:divnix/hive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        paisano.follows = "paisano";
        colmena.follows = "colmena";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
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
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16.url = "github:SenchoPens/base16.nix";

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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        base16.follows = "base16";
        home-manager.follows = "home-manager";
      };
    };
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
    hive.growOn
    {
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

      nixpkgsConfig.allowUnfreePredicate = pkg: true;
      nixpkgsConfig.allowUnfree = true;
      nixpkgsConfig.permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    }
    {
      lib = std.pick self ["common" "lib"];
      devShells = std.harvest self ["common" "devshells"];
      packages = std.harvest self [
        ["common" "generators"]
        ["common" "packages"]
      ];
      pkgs = std.harvest self ["common" "pkgs"];
      # homeModules = std.harvest self ["homebase" "homeModules"];
    }
    {
      nixosConfigurations = collect self "nixosConfigurations";

      nixosProfiles.common = std.harvest self [
        ["common" "nixosProfiles"]
      ];

      nixosProfiles.laptop = std.harvest self [
        ["laptop" "nixosProfiles"]
      ];

      nixosProfiles.server = std.harvest self [
        ["server" "nixosProfiles"]
      ];

      homeConfigurations = collect self "homeConfigurations";

      homeProfiles = std.harvest self [
        ["common" "homeProfiles"]
        ["laptop" "homeProfiles"]
        ["server" "homeProfiles"]
      ];

      colmenaHive = collect self "colmenaConfigurations";

      configFiles = std.harvest self ["common" "configs"];

      formatter."x86_64-linux" =
        inputs.nixpkgs.legacyPackages."x86_64-linux".alejandra;
    };
}
