{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) stdenv;
  inherit (cell) lib;

  packages = with nixpkgs; [statix nil nixfmt nixpkgs-fmt alejandra];
in
  lib.mapAttrs (_: lib.std.lib.dev.mkShell) {
    default = _: {
      name = "Steve";

      imports = [inputs.std.std.devshellProfiles.default];

      packages = with nixpkgs; [
        nixVersions.nix_2_16
        statix
        rnix-lsp
        nixfmt
        nixpkgs-fmt
        alejandra
      ];

      commands = let
        inherit (inputs) nixos-generators;
      in [
        {package = inputs.namaka.packages.default;}
        {
          category = "general commands";
          name = "fmt";
          help = "Format repository";
          command = "nix fmt $PRJ_ROOT";
        }
        (lib.mkIf stdenv.isLinux {
          package = nixos-generators.packages.nixos-generators;
          category = "generate";
        })
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
          command = "nix flake update $PRJ_ROOT $@";
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
      ];
    };
  }
