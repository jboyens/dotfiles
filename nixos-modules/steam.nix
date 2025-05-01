{
  pkgs,
  config,
  ...
}: {
  hardware.graphics.enable32Bit = true;

  programs = {
    gamemode = {
      enable = true;
      enableRenice = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      protontricks.enable = true;
      # extest.enable = true;

      gamescopeSession = {
        enable = true;
      };
    };
  };

  services.xserver.enable = true;
}
