# Author:  JR Boyens w/ original inspiration from Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/jboyens/dotfiles
# License: MIT
{
  description = "An unexpectedly complicated nixos config.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/master"; # for packages on the edge
    # nixpkgs-stable.url = "nixpkgs/nixos-22.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    std.url = "github:divnix/std";
    std.inputs = {
      nixpkgs.follows = "nixpkgs";
      devshell.follows = "devshell";
      nixago.follows = "nixago";
      paisano.follows = "paisano";
    };

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    nixago.url = "github:nix-community/nixago";

    nixos-generators = {
      url = "github:nix-community/nixos-generators/1.7.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixpkgs";
    };

    paisano.url = "github:divnix/paisano";
    paisano.inputs.nixpkgs.follows = "nixpkgs";

    hive.url = "github:jboyens/hive";
    hive.inputs = {
      nixpkgs.follows = "nixpkgs";
      paisano.follows = "paisano";
    };

    namaka.url = "github:nix-community/namaka";
    namaka.inputs.haumea.follows = "haumea";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    persway = {
      url = "github:johnae/persway";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        dream2nix = {
          url = "github:nix-community/dream2nix/legacy";
          inputs.nixpkgs.follows = "nixpkgs";
          inputs.nixpkgsV1.follows = "nixpkgs";
        };
      };
    };

    base16.url = "github:SenchoPens/base16.nix";

    base16-schemes.url = "github:tinted-theming/base16-schemes";
    base16-schemes.flake = false;

    base16-rofi.url = "github:tinted-theming/base16-rofi";
    base16-rofi.flake = false;

    catppuccin.url = "github:catppuccin/base16";
    catppuccin.flake = false;

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # flexe.url = "git+ssh://git@gitlab.com/flexe/nix-releases";
    # flexe.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    # comma = {url = "github:nix-community/comma";};
    # comma.inputs.nixpkgs.follows = "nixpkgs";

    # flexe-flakes.url = "gitlab:flexe/flakes";
    # flexe-flakes.url = "/home/jboyens/Workspace/flexe-flakes";
    # flexe-flakes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    hive,
    std,
    ...
  } @ inputs: let
    lib = inputs.nixpkgs.lib // builtins;
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

        # checks
        (namaka "checks")
      ];

      nixpkgsConfig.allowUnfreePredicate = pkg: true;
      nixpkgsConfig.allowUnfree = true;
      # nixpkgsConfig.allowUnfreePredicate = pkg:
      #   lib.elem (lib.getName pkg) [
      #     "slack"
      #     "spotify"
      #     "zoom"
      #     "google-chrome"
      #     "chromium"
      #     "chromium-unwrapped"
      #     "chrome-widevine-cdm"
      #     "symbola"
      #     "ttf-envy-code-r"
      #     "nvidia-x11"
      #     "nvidia-settings"
      #     "nvidia-persistenced"
      #   ];
    } {
      checks = inputs.namaka.lib.load {
        src = ./tests;
        inputs = {
          inherit lib inputs;
        };
      };
    } {
      lib = std.pick self ["common" "lib"];
      devShells = std.harvest self ["common" "devshells"];
      packages = std.harvest self [
        # ["common" "generators"]
        ["homebase" "packages"]
      ];
      pkgs = std.harvest self ["common" "pkgs"];
      homeModules = std.harvest self ["homebase" "homeModules"];
    } {
      nixosConfigurations = collect self "nixosConfigurations";
      nixosProfiles = std.harvest self [
        ["common" "nixosProfiles"]
        ["homebase" "nixosProfiles"]
      ];
      homeConfigurations = collect self "homeConfigurations";
      homeProfiles = std.harvest self [
        ["common" "homeProfiles"]
        ["homebase" "homeProfiles"]
      ];

      configFiles = std.harvest self ["common" "configs"];

      formatter."x86_64-linux" =
        inputs.nixpkgs.legacyPackages."x86_64-linux".alejandra;
    };
}
