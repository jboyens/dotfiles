{
  lib,
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (self.packages."${system}") bpftune;
in {
  systemd.network.networks = let
    networkConfig = {
      DHCP = "yes";
      Domains = "fooninja.org";
      MulticastDNS = "yes";
    };
  in {
    "90-wireless" = {
      enable = true;
      name = "wl*";
      inherit networkConfig;
      routes = [
        {
          Gateway = "_dhcp4";
          InitialCongestionWindow = 60;
          InitialAdvertisedReceiveWindow = 60;
        }
      ];
      linkConfig = {
        Multicast = true;
      };
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

  # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.network.wait-online.enable = lib.mkForce false;

  environment.etc = {
    "NetworkManager/dnsmasq.d/readme.local-wildcard.conf" = {
      text = ''
        address=/.readme.local/127.0.0.1
      '';
      mode = "0444";
    };
  };

  networking = {
    useDHCP = false;
    wireless = {
      enable = lib.mkDefault false;
      iwd.enable = false;
      iwd.settings = {
        Rank = {
          BandModifier2_4GHz = 0.5;
          BandModifier5GHz = 2.0;
        };
      };
    };
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
    useNetworkd = false;
    domain = "fooninja.org";

    firewall.checkReversePath = "loose";
  };

  services.tailscale.enable = true;
  # taildrive
  services.davfs2.enable = true;

  services.bpftune.enable = true;
  services.bpftune.package = bpftune;
}
