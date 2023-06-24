{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) callPackage;

  load = cell.lib.load inputs cell;

  sources = import ./_sources/generated.nix {
    inherit (nixpkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
  };
in {
  isync-oauth2 = callPackage ./isync-oauth2.nix {inherit sources;};
  cyrus-sasl-xoauth2 = callPackage ./cyrus-sasl-xoauth2.nix {inherit sources;};
  pizauth = callPackage ./pizauth.nix {inherit sources;};
  sloth = callPackage ./sloth.nix {inherit sources;};
  kustomize = callPackage ./kustomize.nix {inherit sources;};
}
