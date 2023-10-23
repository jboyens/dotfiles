{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  lib = cell.lib // nixpkgs.lib;
in {
  systemd.network.networks = let
    networkConfig = {
      DHCP = "yes";
      Domains = "fooninja.org";
    };
  in {
    "90-wireless" = {
      enable = true;
      name = "wl*";
      inherit networkConfig;
    };

    "70-wired" = {
      enable = true;
      name = "en*";
      networkConfig = {
        inherit (networkConfig) Domains;
        DHCP = "yes";
      };

      dhcpV4Config.RouteMetric = 10;
      ipv6AcceptRAConfig.RouteMetric = 10;
    };
  };

  # services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.network.wait-online.enable = lib.mkForce false;

  networking = {
    useDHCP = false;
    wireless.iwd.enable = true;
    useNetworkd = true;
    domain = "fooninja.org";

    firewall.checkReversePath = "loose";
  };
}
