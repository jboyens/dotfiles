{
  pkgs,
  stdenv,
  lib,
  inputs,
  ...
}: {
  ## Local config
  networking.networkmanager.enable = false;
  networking.networkmanager.wifi.powersave = false;
  # networking.networkmanager.wifi.backend = "iwd";

  networking.useNetworkd = true;

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

  # NetworkManager suuuuuuuuuuuuuuuucks
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # systemd.network.wait-online.extraArgs = [ "--any" ];

  networking.wireless.iwd.enable = true;

  networking.domain = "fooninja.org";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  # Strict reverse path filtering breaks Tailscale exit node use and some subnet
  # routing setups.
  networking.firewall.checkReversePath = "loose";

  # https://github.com/NixOS/nixpkgs/issues/135888
  services.nscd.enableNsncd = true;

  services.nfs.idmapd.settings = {
    General = {Domain = "fooninja.org";};

    Translation = {GSS-Methods = "static,nsswitch";};

    Static = {"jboyens@fooninja.org" = "jboyens";};
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  services.tailscale.enable = true;
}
