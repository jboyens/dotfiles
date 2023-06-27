{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  users.jboyens = {
    initialPassword = "nixos";
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "atd"
      "input"
      "plugdev"
      "audio"
      "libvirtd"
      "vboxusers"
      "docker"
      "adbusers"
    ];
    group = "users";
    shell = nixpkgs.zsh;
  };
}
