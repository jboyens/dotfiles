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
        amazon.enable = true;
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
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    # theme.active = "alucard";
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

  services.lorri.enable = true;
  services.thermald.enable = true;
  services.irqbalance.enable = true;

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;
}
