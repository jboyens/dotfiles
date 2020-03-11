# Shiro -- my laptop

{ pkgs, config, ... }:
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

  networking.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.networks = {
    Sledgehammer = {
      psk = "nagasaki";
    };
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
  services.resolved.enable = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [
    pkgs.acpi
    pkgs.linuxPackages.cpupower
    pkgs.my.bosh-cli
    pkgs.my.bosh-bootloader
    pkgs.my.credhub-cli
    pkgs.my.logcli
  ];

  services.psd.enable = true;

  services.lorri.enable = true;

  # Battery life!
  services.tlp.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  # Monitor backlight control
  programs.light.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jboyens" ];

  networking.wireguard.interfaces = {
    production = {
      ips = ["10.50.0.3"];
      privateKeyFile = "/home/${config.my.username}/.secrets/wireguard/production-private.key";
      listenPort = 51821;
      peers = [
        {
          publicKey = "3OapT30c5x8oxbVv/hmbZPjENRiUz17JtksDKcD6Lhs=";
          allowedIPs = [
            "10.50.0.1/32"
            "10.8.0.0/16"
          ];
          endpoint = "52.175.216.108:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    interconnect = {
      ips = [ "10.10.0.3" ];
      privateKeyFile = "/home/${config.my.username}/.secrets/wireguard/interconnect-private.key";
      listenPort = 51820;
      peers = [
        {
          publicKey = "/RFIsNdpsxNma871IgNKgWJUwPg47EsUNR/uGm9vkE0=";
          allowedIPs = [
            "10.10.0.0/24"
            "10.16.0.0/24"
            "10.158.0.0/24"
            "10.74.0.0/24"
            "10.0.0.0/24"
            "10.32.0.0/24"
            "10.34.0.0/24"
            "10.148.0.0/24"
            "10.36.0.0/24"
          ];
          endpoint = "13.66.198.100:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
