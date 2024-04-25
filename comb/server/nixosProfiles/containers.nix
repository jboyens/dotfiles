_: {
  networking.firewall.allowedTCPPorts = [9000];
  services.promtail = {
    enable = true;
    configuration = {
      clients = [
        {url = "http://192.168.86.100:3100/loki/api/v1/push";}
      ];

      scrape_configs = [
        {
          job_name = "system";
          static_configs = [
            {
              targets = ["localhost"];
              labels = {
                job = "varlogs";
                host = "192.168.86.246";
                __path__ = "/var/log/*.log";
              };
            }
          ];
        }
        {
          job_name = "journal";
          journal = {
            labels = {
              job = "systemd-journal";
              host = "192.168.86.246";
            };
            max_age = "12h";
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];

      server = {
        http_listen_port = 9000;
        grpc_listen_port = 0;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    overseerr = {
      image = "sctx/overseerr";
      environment = {
        TZ = "America/Los_Angeles";
        PUID = "1000";
        PGID = "1000";
        LOG_LEVEL = "debug";
      };
      volumes = [
        "/home/jboyens/config/overseerr:/app/config"
      ];
      ports = [
        "5055:5055/tcp"
      ];
    };

    watchtower = {
      image = "ghcr.io/containrrr/watchtower";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      environment = {
        WATCHTOWER_CLEANUP = "true";
        WATCHTOWER_POLL_INTERVAL = "86400";
      };
      extraOptions = [
        "--privileged"
      ];
    };
  };
}
