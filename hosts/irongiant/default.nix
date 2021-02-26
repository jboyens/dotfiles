{ ... }: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix

    ./modules/bitwarden.nix
  ];

  ## Modules
  modules = {
    dev = {
      cc.enable = true;
      cloud = {
        google.enable = true;
        amazon.enable = false;
      };
      db = { postgres.enable = true; };
    };
    editors = {
      default = "nvim";
      emacs.enable = false;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      fs = {
        enable = true;
        ssd.enable = true;
      };
      sensors.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      utils.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      printing.enable = true;
      wireguard = {
        enable = true;
        server.enable = true;
      };
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20u1.useDHCP = true;
  networking.domain = "fooninja.org";

  services.lorri.enable = true;
  services.thermald.enable = true;
  services.irqbalance.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;

  services.prometheus = {
    enable = true;
    exporters.node.enable = true;
    exporters.node.enabledCollectors = [ "systemd" ];
    exporters.snmp.enable = true;
    exporters.snmp.configurationPath = ./files/snmp.yml;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.100:9090" ]; }];
      }
      {
        job_name = "restserver";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.34:8899" ]; }];
      }
      {
        job_name = "node_exporter";
        scrape_interval = "10s";
        static_configs = [
          { targets = [ "192.168.86.34:9100" ]; }
          { targets = [ "192.168.86.100:9100" ]; }
        ];
      }
      {
        job_name = "traefik";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.100:8080" ]; }];
      }
      {
        job_name = "grafana";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.100:3000" ]; }];
      }
      {
        job_name = "pihole";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.34:9617" ]; }];
      }
      {
        job_name = "ping";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.34:9427" ]; }];
      }
      {
        job_name = "docker";
        scrape_interval = "10s";
        static_configs = [{ targets = [ "192.168.86.34:9323" ]; }];
      }
      {
        job_name = "snmp";
        scrape_interval = "10s";
        static_configs = [
          { targets = [ "192.168.86.1" ]; }
          { targets = [ "192.168.86.189" ]; }
        ];
        metrics_path = "/snmp";
        params.module = [ "synology" ];
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "192.168.86.100:9116";
          }
        ];
      }
    ];
  };
  services.grafana = {
    enable = true;
    addr = "0.0.0.0";
    domain = "grafana.fooninja.org";
  };

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;

      server.http_listen_port = 3100;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = { store = "inmemory"; };
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };

      schema_config = {
        configs = [{
          from = "2020-05-15";
          store = "boltdb";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "168h";
          };
        }];
      };

      storage_config = {
        boltdb.directory = "/tmp/loki/index";
        filesystem.directory = "/tmp/loki/chunks";
      };

      limits_config = {
        enforce_metric_name = false;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };
    };
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9000;
        grpc_listen_port = 0;
      };

      positions = { filename = "/tmp/positions.yaml"; };

      clients = [{ url = "http://127.0.0.1:3100/loki/api/v1/push"; }];

      scrape_configs = [{
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = { job = "systemd-journal"; };
        };

        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }];
      }];
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8080 3000 9116 ];

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
  };

  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {
    log.level = "WARN";
    # accessLog.format = "json";
    api.dashboard = true;
    api.insecure = true;

    metrics.prometheus = { };

    entryPoints.http.address = "0.0.0.0:80";
    entryPoints.https.address = "0.0.0.0:443";
    entryPoints.traefik.address = "0.0.0.0:8080";

    certificatesResolvers.letsencrypt.acme = {
      email = "jboyens@fooninja.org";
      storage = "/run/secrets/acme.json";
      httpChallenge.entryPoint = "http";
    };
  };

  services.traefik.dynamicConfigOptions = {
    http.routers = {
      ha-host = {
        rule = "Host(`ha.fooninja.org`)";
        service = "ha";
      };

      sonarr-host = {
        rule = "Host(`sonarr.fooninja.org`)";
        service = "sonarr";
      };

      grafana-host = {
        rule = "Host(`grafana.fooninja.org`)";
        service = "grafana";
      };

      prometheus-host = {
        rule = "Host(`prometheus.fooninja.org`)";
        service = "prometheus";
      };

      bitwarden-host = {
        rule = "Host(`bw.fooninja.org`)";
        service = "bitwarden";
        tls.certResolver = "letsencrypt";
      };
    };

    http.services.ha.loadBalancer.servers =
      [{ url = "http://192.168.86.34:8123"; }];
    http.services.sonarr.loadBalancer.servers =
      [{ url = "http://192.168.86.34:8989"; }];
    http.services.grafana.loadBalancer.servers =
      [{ url = "http://localhost:3000"; }];
    http.services.prometheus.loadBalancer.servers =
      [{ url = "http://localhost:9090"; }];
    http.services.bitwarden.loadBalancer.servers =
      [{ url = "http://localhost:8000"; }];
  };
}
