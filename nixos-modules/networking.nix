{lib, ...}: {
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
      routes = [
        {
          Gateway = "_dhcp4";
          InitialCongestionWindow = 60;
          InitialAdvertisedReceiveWindow = 60;
        }
      ];
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

  networking = {
    useDHCP = false;
    wireless = {
      enable = false;
      iwd.enable = true;
      iwd.settings = {
        Rank = {
          BandModifier2_4GHz = 0.5;
          BandModifier5GHz = 2.0;
        };
      };
    };
    networkmanager.enable = false;
    useNetworkd = true;
    domain = "fooninja.org";

    firewall.checkReversePath = "loose";
  };

  services.tailscale.enable = true;
  services.bpftune.enable = true;
}
