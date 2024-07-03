{
  config,
  pkgs,
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
    initExtra = ''
      fpath+="${pkgs.script-directory}/share/zsh/site-functions"
    '';
  };
}
