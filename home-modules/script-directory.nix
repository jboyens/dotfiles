{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.script-directory = {
    enable = true;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/sd";
      SD_EDITOR = "nvim";
      SD_CAT = "bat";
    };
  };

  programs.zsh = {
    initContent = lib.mkOrder 550 ''
      fpath+="${pkgs.script-directory}/share/zsh/site-functions"
    '';
  };
}
