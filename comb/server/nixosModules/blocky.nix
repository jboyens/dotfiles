{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs.cells.common) lib pkgs;
  inherit (inputs.cells.common.pkgs) writeTextFile;

  cfg = config.services.blocky;
in {
  options = {
    enable = lib.mkEnableOption "Run blocky DNS server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "spx01/blocky:latest";
    };

    configuration = lib.mkOption {
      inherit (pkgs.formats.json {}) type;
      default = {
        blocking = {
          blackLists = {
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
            noblock = [];
          };
          clientGroupsBlock = {default = ["ads"];};
          whiteLists = {ads = ["/app/whitelist.txt"];};
        };
        bootstrapDns = "8.8.8.8:53";
        clientLookup = {upstream = "192.168.86.1";};
        customDNS = {
          mapping = {
            "ap.fooninja.org" = "192.168.86.189";
            "grafana.fooninja.org" = "192.168.86.100";
            "ha.fooninja.org" = "192.168.86.100";
            "irongiant.fooninja.org" = "192.168.86.100";
            "prometheus.fooninja.org" = "192.168.86.100";
            "router.fooninja.org" = "192.168.86.1";
            "sonarr.fooninja.org" = "192.168.86.100";
          };
        };
        disableIPv6 = true;
        httpPort = 4000;
        port = 53;
        prometheus = {enable = true;};
        upstream = {default = ["8.8.8.8" "1.1.1.1" "8.8.4.4" "1.0.0.1"];};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [9000];
    virtualisation.oci-containers.containers.blocky = let
      configFile = writeTextFile {
        name = "blocky-config.yaml";
        text = builtins.toJSON cfg.configuration;
      };
      whitelist = writeTextFile {
        name = "blocky-whitelist.txt";
        text = ''
        '';
      };
    in {
      inherit (cfg) image;

      volumes = [
        "${configFile}:/app/config.yml"
        "${whitelist}:/app/whitelist.txt"
      ];

      environment = {
        TZ = "America/Los_Angeles";
      };

      extraOptions = [
        "--network=host"
        "--dns=8.8.8.8,1.1.1.1,8.8.4.4,1.0.0.1"
      ];

      ports = [
        "54:54/tcp"
        "54:54/udp"
        "4000:4000/tcp"
      ];
    };
  };
}
