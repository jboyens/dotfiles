{
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
}
