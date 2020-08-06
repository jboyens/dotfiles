{ pkgs ? import <nixpkgs> {} }:

with pkgs;
{
  ant-dracula = (callPackage ./ant-dracula.nix { });
  bosh-bootloader = (callPackage ./bosh-bootloader.nix { });
  bosh-cli = (callPackage ./bosh-cli.nix { });
  cached-nix-shell = (callPackage (builtins.fetchTarball "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz") { });
  credhub-cli = (callPackage ./credhub-cli.nix { });
# dell-bios-fan-control = (callPackage ./packages/dell-bios-fan-control.nix {});
  ferdi = (callPackage ./ferdi.nix { });
  gmailctl = (callPackage ./gmailctl.nix { });
  linode-cli = (callPackage ./linode-cli.nix { });
  logcli = (callPackage ./logcli.nix { });
  ripcord = (callPackage ./ripcord.nix { });
  zunit = (callPackage ./zunit.nix { });
  hll2350dw = (callPackage ./hll2350dw.nix { });
  "3mux" = (callPackage ./3mux { });
  autotiling = (callPackage ./autotiling.nix { });
  broxy = (callPackage ./broxy.nix { });
  glab = (callPackage ./glab.nix { });
  pragli = (callPackage ./pragli.nix { });
  tanka = (callPackage ./tanka.nix { });
  wldash = (callPackage ./wldash.nix { });
}
