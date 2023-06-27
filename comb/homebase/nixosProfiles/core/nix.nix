{
  inputs,
  cell,
}: let
  inherit (cell) lib;

  # Hive or Std or Paisano or something treats nixpkgs as "special"
  # this breaks nixpkgs.outPath so we've got to filter it
  filteredInputs = lib.filterAttrs (n: _: n != "self" && n != "cells" && n != "nixpkgs") inputs;
  nixPathInputs = lib.mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
  registryInputs = lib.mapAttrs (_: v: {flake = v;}) filteredInputs;
in {
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  settings = {
    sandbox = true;

    trusted-users = ["root" "@wheel"];
    allowed-users = ["@wheel"];

    auto-optimise-store = true;
  };

  # HACK
  nixPath =
    nixPathInputs
    ++ [
      "nixpkgs=${inputs.std.inputs.nixpkgs}"
    ];

  registry = registryInputs // {nixpkgs.flake = inputs.std.inputs.nixpkgs;};

  extraOptions = ''
    experimental-features = nix-command flakes
    min-free = 536870912
    keep-outputs = true
    keep-derivations = true
    fallback = true
  '';
}
