{ ... }:
{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    dev = {
      cc.enable = true;
      cloud = {
        google.enable = true;
        amazon.enable = false;
      };
      db = {
        postgres.enable = true;
      };
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
      git.enable    = true;
      gnupg.enable  = true;
      pass.enable   = true;
      tmux.enable   = true;
      zsh.enable    = true;
      utils.enable  = true;
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
  networking.firewall.enable = false;

  services.lorri.enable = true;
  services.thermald.enable = true;
  services.irqbalance.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;

  services.traefik.enable = true;
  services.traefik.staticConfigOptions = {
    log.level = "DEBUG";
    accessLog.format = "json";
    api.dashboard = true;
    api.insecure = true;

    entryPoints.http.address = "0.0.0.0:80";
    entryPoints.traefik.address = "0.0.0.0:8080";
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
    };

    http.services.ha.loadBalancer.servers = [{ url = "http://192.168.86.34:8123"; }];
    http.services.sonarr.loadBalancer.servers = [{ url = "http://192.168.86.34:8989"; }];
  };
}
