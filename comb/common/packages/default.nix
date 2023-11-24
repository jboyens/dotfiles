{
  inputs,
  cell,
}: let
  inherit (cell) pkgs;
  inherit (pkgs) callPackage stdenv;

  l = cell.lib // builtins;

  sources = callPackage ./_sources/generated.nix {};
  mkPackage = path: callPackage path {inherit sources;};
  mkPackages = list:
    l.mapAttrs (_: mkPackage) (l.listToAttrs (l.flatten (l.map (e: {
        name = e;
        value = ./. + "/${e}.nix";
      })
      list)));
in
  mkPackages ([
      "isync-oauth2"
      "cyrus-sasl-xoauth2"
      "pizauth"
      "pragmasevka"
      "slack"
      "sloth"
      "kustomize"
      "grizzly"
      "tilt"
      "testkube"
      "swaync"
    ]
    ++ cell.lib.optional (!stdenv.isDarwin) "fuzzel")
  // {
    gnupg = callPackage ./gnupg {};
    devpod-cli = callPackage ./devpod-cli.nix {};
  }
