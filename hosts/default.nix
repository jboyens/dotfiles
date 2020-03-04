# hosts/default.nix --- settings common to all my systems

{ pkgs, ... }:
{
  # Just the bear necessities~
  environment.systemPackages = with pkgs; [
    coreutils
    git
    killall
    unzip
    vim
    wget
    sshfs
  ];


  ### My user settings
  my.username = "jboyens";
  my.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };
}
