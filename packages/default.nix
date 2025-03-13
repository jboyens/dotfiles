{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) callPackage stdenv;

  sources = callPackage ./_sources/generated.nix {};
  mkPackage = path: callPackage path {inherit sources;};
  mkPackages = list:
    lib.mapAttrs (_: mkPackage) (lib.listToAttrs (lib.flatten (lib.map (e: {
        name = e;
        value = ./. + "/${e}.nix";
      })
      list)));
in
  mkPackages [
    "isync-oauth2"
    "cyrus-sasl-xoauth2"
    "pizauth"
    "pragmasevka"
    "moment"
  ]
  // {
    gnupg = callPackage ./gnupg {};
  }
