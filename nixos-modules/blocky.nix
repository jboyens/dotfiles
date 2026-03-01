_: {
  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = ["8.8.8.8" "1.1.1.1" "8.8.4.4" "1.0.0.1"];

      bootstrapDns = "8.8.8.8:53";

      blocking = {
        blackLists.ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
        clientGroupsBlock.default = ["ads"];
      };

      clientLookup.upstream = "192.168.86.1";

      customDNS.mapping = {
        "ap.fooninja.org" = "192.168.86.189";
        "grafana.fooninja.org" = "192.168.86.100";
        "ha.fooninja.org" = "192.168.86.100";
        "irongiant.fooninja.org" = "192.168.86.100";
        "prometheus.fooninja.org" = "192.168.86.100";
        "router.fooninja.org" = "192.168.86.1";
        "sonarr.fooninja.org" = "192.168.86.100";
      };

      ports.dns = 53;
      ports.http = 4000;

      prometheus.enable = true;
    };
  };

  networking.firewall.allowedTCPPorts = [53 4000];
  networking.firewall.allowedUDPPorts = [53];
}
