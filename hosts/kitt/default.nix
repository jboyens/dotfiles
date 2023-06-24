{
  pkgs,
  stdenv,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [../home.nix ./hardware-configuration.nix ./networking.nix];

  ## Modules
  modules = {
    desktop = {
      swaywm.enable = true;
      i3.enable = false;
      apps = {
        bitwarden.enable = true;
        maestral.enable = true;
        rofi.enable = true;
        signal-desktop.enable = true;
        slack.enable = true;
        zoom.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = true;
      };
      media = {
        documents.enable = true;
        documents.pdf.enable = true;
        mpv.enable = true;
        spotify.enable = true;
      };
      services = {
        gammastep.enable = true;
        kanshi.enable = true;
        waybar.enable = true;
      };
      term = {
        default = "foot";
        foot.enable = true;
        alacritty.enable = true;
      };
      vm = {qemu.enable = true;};
    };
    dev = {
      android.enable = false;
      cc.enable = true;
      rust.enable = true;
      go.enable = true;
      node.enable = true;
      cloud = {
        enable = true;
        google.enable = true;
      };
      db = {postgres.enable = true;};
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
      ergodox.enable = true;
      nvidia.enable = false;
      solokeys.enable = true;
      sony-1000Xm3.enable = true;
      firmware.enable = true;
      fs = {
        enable = true;
        # zfs.enable = true;
        ssd.enable = true;
      };
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
      weechat.enable = false;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      # mpd.enable = true;
      podman.enable = false;
      printing.enable = true;
      geoclue2.enable = true;
      tlp.enable = true;
      restic = {
        enable = true;
        backups = {
          workspace.enable = true;
          home.enable = true;
          mail.enable = true;
        };
      };
      syncthing.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "base16";
  };

  services.atd.enable = true;
  services.pcscd.enable = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;
  gtk.iconCache.enable = true;

  security.pam = {
    loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];

    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  nix.settings.netrc-file = config.age.secrets.netrc.path;

  time.timeZone = "America/Los_Angeles";

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
    persistent = true;
  };

  # specialisation = {
  #   kde.configuration = {
  #     services.xserver.enable = true;
  #     services.xserver.displayManager.sddm.enable = true;
  #     services.xserver.desktopManager.plasma5.enable = true;
  #
  #     environment.systemPackages = [
  #       pkgs.plasma5Packages.bismuth
  #     ];
  #   };
  #   gnome.configuration = {
  #     services.xserver.enable = true;
  #     services.xserver.desktopManager.gnome.enable = true;
  #     services.xserver.displayManager.gdm.enable = true;
  #     services.xserver.displayManager.gdm.wayland = true;
  #     hardware.pulseaudio.enable = false;
  #   };
  # };
}
