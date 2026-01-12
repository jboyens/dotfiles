{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.nixvim.homeModules.nixvim];

  xdg = {
    enable = true;
    portal.xdgOpenUsePortal = true;
  };

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

      chromium

      evince
      zathura

      mpv
      mpvc

      spotify

      signal-desktop
      slack
      # zoom-us
      # (zoom-us.overrideAttrs {
      #   version = "6.2.11.5069";
      #   src = pkgs.fetchurl {
      #     url = "https://zoom.us/client/6.2.11.5069/zoom_x86_64.pkg.tar.xz";
      #     hash = "sha256-k8T/lmfgAFxW1nwEyh61lagrlHP5geT2tA7e5j61+qw=";
      #   };
      # })
      discord

      brightnessctl
      playerctl

      ydotool

      # polkit_gnome

      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = ["Development"];
      })

      xfce.thunar

      # qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
      # kdePackages.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
      paper-icon-theme

      xdg-utils

      rofi-bluetooth
      rofi-power-menu
      rofi-pulse-select
      rofi-rbw
      rofi-systemd

      # Fake rofi dmenu entries
      (makeDesktopItem {
        name = "rofi-browsermenu";
        desktopName = "Open Bookmark in Browser";
        icon = "bookmark-new-symbolic";
        exec = "\\$DOTFILES_BIN/rofi/browsermenu";
      })

      (makeDesktopItem {
        name = "rofi-browsermenu-history";
        desktopName = "Open Browser History";
        icon = "accessories-clock";
        exec = "\\$DOTFILES_BIN/rofi/browsermenu history";
      })

      (makeDesktopItem {
        name = "rofi-filemenu";
        desktopName = "Open Directory in Terminal";
        icon = "folder";
        exec = "\\$DOTFILES_BIN/rofi/filemenu";
      })

      (makeDesktopItem {
        name = "rofi-filemenu-scratch";
        desktopName = "Open Directory in Scratch Terminal";
        icon = "folder";
        exec = "\\$DOTFILES_BIN/rofi/filemenu -x";
      })

      (makeDesktopItem {
        name = "lock-display";
        desktopName = "Lock screen";
        icon = "system-lock-screen";
        exec = "\\$DOTFILES_BIN/zzz";
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

      # sound
      pavucontrol
      # broken 10/8/2025
      # pamixer

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
    zsh.initContent = lib.mkOrder 550 (
      lib.concatStringsSep "\n" [
        ''
          ### docker aliases
          alias dk=docker
          alias dkc=docker-compose
          alias dkm=docker-machine
          alias dkl='dk logs'
          alias dkcl='dkc logs'

          dkclr() {
            dk stop $(docker ps -a -q)
            dk rm $(docker ps -a -q)
          }

          dke() {
            dk exec -it "$1" "''${@:1}"
          }
          ### end aliases
        ''
      ]
    );

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

    chromium.enable = true;
  };

  # systemd.user.services."maestral-daemon@maestral" = {
  #   Unit = {Description = "Maestral daemon for the config %i";};
  #
  #   Service = {
  #     Type = "notify";
  #     ExecStart = "${maestral}/bin/maestral start -f -c %i";
  #     ExecStop = "${maestral}/bin/maestral stop";
  #     WatchdogSec = "30s";
  #   };
  #
  #   Install = {WantedBy = ["default.target"];};
  # };

  # services = {xserver.enable = lib.mkDefault false;};

  services.mpris-proxy.enable = true;
  services.tailscale-systray.enable = true;

  home.pointerCursor = {
    package = lib.mkDefault pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = alacritty ] && export TERM=xterm-256color
  # '';
}
