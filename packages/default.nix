{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  moment = callPackage ./moment.nix {};
  moment-staging = callPackage ./moment-staging.nix {};
  pizauth = callPackage ./pizauth.nix {};
  pragmasevka = callPackage ./pragmasevka.nix {};
  isync-oauth2 = callPackage ./isync-oauth2.nix {};
  cyrus-sasl-xoauth2 = callPackage ./cyrus-sasl-xoauth2.nix {};
  bpftune = callPackage ./bpftune.nix {};
  jj-fzf = callPackage ./jj-fzf {};
}
