{ ... }:
{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = false;
      swaywm.enable = true;
      apps = {
        discord.enable = true;
        slack.enable = true;
        rofi.enable = true;
        zoom.enable = true;
        # godot.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        chromium.enable = true;
      };
      gaming = {
        steam.enable = true;
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
        recording.enable = false;
        spotify.enable = true;
      };
      term = {
        default = "alacritty";
        st.enable = false;
        alacritty.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      cc.enable = true;
      cloud = {
        google.enable = true;
        amazon.enable = true;
      };
      db = {
        postgres.enable = true;
      };
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    hardware = {
      audio.enable = true;
      ergodox.enable = true;
      fs = {
        enable = true;
        # zfs.enable = true;
        ssd.enable = true;
      };
      # nvidia.enable = true;
      sensors.enable = true;
    };
    email = {
      mu4e.enable = true;
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
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;

  services.lorri.enable = true;
  services.blueman.enable = true;
  services.geoclue2.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  services.thermald.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  services.pcscd.enable = true;
  services.tlp.enable = true;
  powerManagement.enable = true;
  # powerManagement.powertop.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  programs.light.enable = true;
  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;
}
