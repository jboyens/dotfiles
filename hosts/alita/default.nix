# Shiro -- my laptop

{ pkgs, ... }:
{
  imports = [
    ../personal.nix   # common settings
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/laptop/hdd>
    ./hardware-configuration.nix
    ## Dekstop environment
    <modules/desktop/bspwm.nix>
    ## Apps
    <modules/browser/firefox.nix>
    <modules/dev>
    <modules/dev/node.nix>
    <modules/dev/podman.nix>
    <modules/editors/emacs.nix>
    <modules/editors/vim.nix>
    <modules/shell/direnv.nix>
    <modules/shell/git.nix>
    <modules/shell/utils.nix>
    <modules/shell/gnupg.nix>
    <modules/shell/pass.nix>
    <modules/shell/tmux.nix>
    <modules/shell/zsh.nix>
    ## Project-based
    <modules/chat.nix>       # discord, mainly
    <modules/recording.nix>  # recording video & audio
    <modules/music.nix>      # playing music
    <modules/backup/restic.nix>
    # <modules/vm.nix>         # virtualbox for testing
    ## Services
    <modules/services/syncthing.nix>
    <modules/services/ssh.nix>
    ## Theme
    <modules/themes/aquanaut>
  ];

  systemd.targets.iwd.after = ["systemd-networkd"];

  networking = {
    useDHCP = false;
    useNetworkd = true;
    wireless.iwd.enable = true;
    interfaces = {
      enp3s0 = {
        useDHCP = true;
      };

      wlan0 = {
        useDHCP = true;
      };
    };
    # wireless = {
    #   enable = true;
    #   networks = {
    #     "Sledgehammer" = {
    #       psk = "nagasaki";
    #     };
    #   };
    # };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mitigations=off" ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable = true;

  services.xserver.libinput = {
    enable = true;
    tapping = true;
    clickMethod = "clickfinger";
  };
  services.blueman.enable = true;

  # services.xserver.exportConfiguration = true;
  services.xserver.xkbModel = "dell";
  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";

  services.thermald.enable = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [
    pkgs.acpi
    pkgs.linuxPackages.cpupower
  ];

  services.psd.enable = true;

  # Battery life!
  services.tlp.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  # Monitor backlight control
  programs.light.enable = true;
}
