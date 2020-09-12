# Kitt -- my work laptop

{ pkgs, config, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
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

    dev = {
      node.enable = true;
      ruby.enable = true;
      cloud.google.enable = true;
      podman.enable = true;
      db.enable = true;
    };

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
      printing.enable = true;
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
  services.geoclue2.enable = true;
  services.fwupd.enable = true;
  services.pipewire.enable = true;

  services.xserver.xkbModel = "dell";
  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";
  console.useXkbConfig = true;

  services.thermald.enable = true;
  # services.resolved.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;

  programs.sway.enable = true;

  programs.ssh.startAgent = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [
    pkgs.acpi
    pkgs.linuxPackages.cpupower
    pkgs.my.logcli
    # pkgs.my.ferdi
    pkgs.my.glab
    pkgs.my.git-delete-merged-branches
    pkgs.lxqt.lxqt-policykit
  ];

  services.psd.enable = false;
  services.upower.enable = true;
  services.lorri.enable = true;

  # YubiKey
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.pcscd.enable = true;

  # Battery life!
  services.tlp.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = false;

  programs.light.enable = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.dconf.enable = true;
}
