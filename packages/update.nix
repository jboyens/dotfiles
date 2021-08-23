{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  adl = (callPackage ./adl.nix { });
  anime-downloader = (callPackage ./anime-downloader.nix { });
  bitwarden-gui = (callPackage ./bitwarden-gui.nix { });
  bosh-cli = (callPackage ./bosh-cli.nix { });
  fennel = (callPackage ./fennel.nix { });
  flashfocus = (callPackage ./flashfocus.nix { });
  git-delete-merged-branches = (callPackage ./git-delete-merged-branches.nix { });
  git-sync = (callPackage ./git-sync.nix { });
  hll2350dw-cups = (callPackage ./hll2350dw-cups.nix { });
  krew = (callPackage ./krew.nix { });
  remontoire = (callPackage ./remontoire.nix { });
  sony-headphones-client = (callPackage ./sony-headphones-client.nix { });
  trackma = (callPackage ./trackma.nix { });
  wl-clipboard-x11 = (callPackage ./wl-clipboard-x11.nix { });
}
