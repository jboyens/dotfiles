{ pkgs, stdenv, lib, ... }:
{
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = false;
      swaywm.enable = true;
      apps = {
        bitwarden.enable = true;
        slack.enable = true;
        rofi.enable = true;
        zoom.enable = true;
        maestral.enable = true;
        # godot.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = false;
        qutebrowser = {
          enable = false;
          extraConfig = ''
            c.colors.webpage.prefers_color_scheme_dark = True
          '';
        };
      };
      gaming = {
        steam.enable = false;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        daw.enable = false;
        documents.enable = true;
        documents.pdf.enable = true;
        graphics = {
          enable = true;
          tools.enable = true;
          raster.enable = false;
          vector.enable = false;
          sprites.enable = false;
        };
        mpv.enable = true;
        recording.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "foot";
        st.enable = false;
        alacritty.enable = true;
        foot.enable = true;
      };
      vm = { qemu.enable = true; };
    };
    dev = {
      android.enable = true;
      cc.enable = true;
      rust.enable = true;
      go.enable = true;
      node = {
        enable = true;
        enableGlobally = true;
      };
      cloud = {
        enable = true;
        google.enable = true;
        # currently broken
        amazon.enable = false;
      };
      db = { postgres.enable = true; };
      ruby.enable = true;
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      bluetooth.audio.enable = false;
      ergodox.enable = true;
      sony-1000Xm3.enable = true;
      fs = {
        enable = true;
        # zfs.enable = true;
        ssd.enable = true;
      };
      nvidia.enable = false;
      sensors.enable = true;
    };
    email = {
      mu4e.enable = true;
      mu4e.package = pkgs.unstable.offlineimap;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      utils.enable = true;
      vaultwarden.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      # mpd.enable = true;
      podman.enable = false;
      printing.enable = true;
      restic = {
        enable = true;
        backups = {
          workspace.enable = true;
          home.enable = true;
          mail.enable = true;
        };
      };
      syncthing.enable = true;
      wireguard = {
        enable = false;
        client.enable = false;
      };
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "nord";
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  services.prometheus.exporters.node = {
    enable = false;
    openFirewall = true;
    enabledCollectors = [ "systemd" ];
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";

  networking.domain = "fooninja.org";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  services.lorri.enable = true;
  services.blueman.enable = true;
  #broken on unstable
  services.geoclue2.enable = true;
  services.geoclue2.enableDemoAgent = true;
  services.geoclue2.appConfig = {
    "gammastep" = {
      isAllowed = true;
      isSystem = false;
      users = [];
    };
    "redshift" = {
      isAllowed = true;
      isSystem = false;
      users = [];
    };
    "org.freedesktop.DBus" = {
      isAllowed = true;
      isSystem = true;
      users = [];
    };
  };
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  services.tailscale.enable = true;
  services.thermald.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  services.pcscd.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  };
  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  services.nfs.idmapd.settings = {
    General = {
      Domain = "fooninja.org";
    };

    Translation = {
      GSS-Methods="static,nsswitch";
    };

    Static = {
      "jboyens@fooninja.org" = "jboyens";
    };
  };

  programs.light.enable = true;
  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
    # gtkUsePortal = true;
  };
}
