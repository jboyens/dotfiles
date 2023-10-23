{
  lib,
  gnupg,
  callPackage,
  ...
}: let
  sources = callPackage ./../_sources/generated.nix {};
in
  gnupg.overrideAttrs (oa: {
    inherit (sources.gnupg) src;
    version = lib.removePrefix "gnupg-" sources.gnupg.version;
  })
