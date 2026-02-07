{
  pkgs,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  xdg.enable = true;

  home = {
    packages = with pkgs; [
      # ripgrep
      sudo
      bottom
      # my.fzf
      inputs.nixpkgs-unstable.legacyPackages."${system}".fzf
      eza

      shellcheck

      editorconfig-core-c

      # maestral
      # maestral-gui

      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${pkgs.tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = [ "Development" ];
      })

      # for calculations
      bc

      # for watching networks
      bwm_ng

      # for guessing mime-types
      file

      # for checking out block devices
      hdparm

      # for checking in on block devices
      iotop

      # for understanding who has what open
      lsof

      # for running commands repeatedly
      entr

      # for downloading things rapidly
      axel

      # for monitoring
      bottom
      btop

      # for json parsing
      jq

      # for yaml parsing
      yq-go

      # for pretty du
      dust

      # dig
      bind

      # network
      mtr

      # zips
      unzip

      # certs/keys
      openssl

      # wireless
      iw

      # notify-send
      libnotify

      # wl-clipboard-x11

      envsubst

      age

      nvd

      postgresql
      pgcenter

      self.packages.${pkgs.stdenv.hostPlatform.system}.jj-fzf
      jujutsu
    ];

    sessionVariables = {
      GNUPGHOME = "${config.xdg.configHome}/gnupg";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      MACHINE_STORAGE_PATH = "${config.xdg.dataHome}/docker/machine";

      EDITOR = "nvim";
      BROWSER = "firefox";
    };

    shellAliases = {
      vim = "nvim";
      v = "nvim";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        dracula-nvim
      ];
      initLua = ''
        vim.cmd [[source ~/.config/nvim/init-custom.vim]]
      '';
    };

    bat.enable = true;

    broot.enable = true;
    broot.enableZshIntegration = true;
  };
}
