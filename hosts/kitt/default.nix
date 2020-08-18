# Kitt -- my work laptop

{ pkgs, config, lib, ... }: {
  imports = [
    ../personal.nix # common settings
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/laptop/hdd>
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      bspwm.enable = false;
      swaywm.enable = true;

      apps = {
        rofi.enable = true;
        discord.enable = true;
        slack.enable = true;
        vm.enable = true;
        zoom.enable = true;
        dbeaver.enable = true;
      };

      term.default = "xst";
      term.st.enable = true;

      browsers = {
        default = "firefox";
        firefox.enable = true;
        google-chrome.enable = true;
        vivaldi.enable = false;
        qutebrowser.enable = true;
      };

      gaming = {
        steam.enable = true;
        factorio.enable = false;
        dwarf-fortress.enable = true;
        emulators = {
          psx.enable = false; # Playstation
          ds.enable = false; # Nintendo DS
          gb.enable = false; # GameBoy + GameBoy Color
          gba.enable = false; # GameBoy Advance
          snes.enable = true; # Super Nintendo
        };
      };

    };

    dev.node.enable = true;
    dev.cloud.google.enable = true;
    dev.podman.enable = true;
    dev.db.enable = true;

    editors = {
      default = "emacs";
      emacs.enable = true;
      vim.enable = true;
      vscode.enable = true;
    };

    email = { mu.enable = true; };

    media = { spotify.enable = true; };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      pgcenter.enable = true;
      tmux.enable = true;
      ranger.enable = true;
      zsh.enable = true;
      utils.enable = true;
    };

    services = {
      syncthing.enable = true;
      ssh.enable = true;
      docker.enable = true;
      calibre.enable = false;
    };

    themes.fluorescence.enable = true;
  };

  networking.wireless.iwd.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  services.xserver.libinput = {
    enable = true;
    tapping = true;
    clickMethod = "clickfinger";
  };
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  # services.xserver.exportConfiguration = true;
  services.xserver.xkbModel = "dell";
  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";
  services.xserver.videoDrivers = [ "intel" "nouveau" ];
  services.xserver.exportConfiguration = true;
  services.xserver.useGlamor = true;
  services.xserver.deviceSection = ''
    Option "DRI" "3"
  '';
  console.useXkbConfig = true;

  services.thermald.enable = true;
  # services.resolved.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.my.hll2350dw ];

  hardware.printers.ensureDefaultPrinter = "HLL2350DW";
  hardware.printers.ensurePrinters = [{
    name = "HLL2350DW";
    deviceUri = "socket://192.168.86.39:9100";
    model = "brother-HLL2350DW-cups-en.ppd";
    ppdOptions = {
      Duplex = "DuplexNoTumble";
      PageSize = "Letter";
    };
  }];

  programs.system-config-printer.enable = true;
  programs.sway.enable = true;
  programs.ssh.startAgent = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [
    pkgs.acpi
    pkgs.linuxPackages.cpupower
    # Respect XDG conventions, damn it!
    # (pkgs.writeScriptBin "nvidia-settings" ''
    #   #!${pkgs.stdenv.shell}
    #   mkdir -p "$XDG_CONFIG_HOME/nvidia"
    #   exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
    # '')
    # pkgs.my.bosh-cli
    # pkgs.my.bosh-bootloader
    # pkgs.my.credhub-cli
    pkgs.my.logcli
    pkgs.my.ferdi
    pkgs.my.glab
    pkgs.my.git-delete-merged-branches
    # pkgs.my.gmailctl
    # pkgs.my."3mux"
    # pkgs.my.tanka

    pkgs.lxqt.lxqt-policykit
  ];

  services.psd.enable = true;
  services.upower.enable = true;
  services.lorri.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.pcscd.enable = true;
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome3.gvfs;
  };

  services.samba = {
    enable = true;
    securityType = "user";
  };

  # Battery life!
  services.tlp.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = false;

  programs.light.enable = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;

  networking.wireguard.interfaces = { };
}
