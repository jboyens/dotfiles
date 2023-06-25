{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;
in
  lib.mapAttrs (_: lib.std.lib.dev.mkShell) {
    default = _: {
      name = "Steve";

      imports = [inputs.std.std.devshellProfiles.default];

      packages = with nixpkgs; [statix nil nixfmt nixpkgs-fmt alejandra];

      commands = let
        inherit (inputs) nixos-generators;
      in [
        {
          category = "general commands";
          name = "fmt";
          help = "Format repository";
          command = "nix fmt $PRJ_ROOT";
        }
        {
          package = nixos-generators.packages.nixos-generators;
          category = "generate";
        }
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
          name = "test";
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
      ];
    };
  }
