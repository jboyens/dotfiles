# Shiro -- my laptop

{ pkgs, ... }:
{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix
    ## Dekstop environment
    <modules/desktop/bspwm.nix>
    ## Apps
    <modules/browser/firefox.nix>
    <modules/dev>
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

  networking = {
    wireless = {
      enable = true;
      networks = {
        "Sledgehammer" = {
          psk = "nagasaki";
        };
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mitigations=off" ];

  hardware.opengl.enable = true;

  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [ pkgs.acpi ];
  powerManagement.powertop.enable = true;
  # Monitor backlight control
  programs.light.enable = true;
}
