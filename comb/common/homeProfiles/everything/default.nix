{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;

  lib = cell.lib // nixpkgs.lib // builtins;

  my = inputs.cells.common.packages;

  work-cloud = with nixpkgs; [
    go-jsonnet
    # broken 2023-08-18
    # hadolint
    istioctl
    kind
    krew
    kube3d
    kubectl
    kubernetes-helm
    kustomize
    minikube
    (open-policy-agent.overrideAttrs (_: {doCheck = false;}))
    stern
    terraform
    tilt
    # sloth
  ];

  google-cloud = with nixpkgs; [
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.config-connector
      google-cloud-sdk.components.terraform-tools
    ])
    # cloud-sql-proxy
  ];

  postgres = with nixpkgs; [
    postgresql
    pgcenter
  ];
in {
  imports = [
    cell.homeProfiles.styling
  ];

  xdg.enable = true;

  home.packages = with nixpkgs;
    [
      # ripgrep
      sudo
      bottom
      fzf
      eza

      # clang
      (lib.hiPrio gcc)
      # bear
      gdb
      cmake
      # llvmPackages.libcxx

      go
      gopls
      gocode
      gore
      gotools
      gotests
      gomodifytags
      golangci-lint
      delve

      (lib.hiPrio ruby_3_2)
      solargraph

      shellcheck

      easyeffects

      editorconfig-core-c

      bitwarden

      maestral
      maestral-gui

      element-desktop
      signal-desktop
      beeper
      slack
      (makeDesktopItem {
        name = "Slack (WebRTC)";
        desktopName = "Slack (WebRTC)";
        genericName = "Open Slack w/ WebRTC";
        icon = "slack";
        exec = "${nixpkgs.slack}/bin/slack --enable-features=WebRTCPipeWireCapturer %U";
        categories = ["Network"];
      })
      zoom-us
      (makeDesktopItem {
        name = "Google Meet";
        desktopName = "Google Meet";
        genericName = "Open Google Meet";
        icon = "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Default";
        exec = "chromium \"--profile-directory=Profile\ 1\" --app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan --ozone-platform-hint=auto";
        categories = ["Network"];
      })

      brave
      chromium

      evince
      zathura

      mpv
      mpvc

      spotify

      brightnessctl
      playerctl

      ydotool

      polkit_gnome

      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = ["Development"];
      })

      xfce.thunar

      qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
      libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
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
      du-dust

      # dig
      bind

      # sound
      pavucontrol
      pamixer

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

      wl-clipboard-x11

      envsubst

      age

      glab

      jira-cli-go

      my.testkube

      nvd

      # markdown-to-confluence

      # autotiling
      fuzzel
      grim
      qt5.qtwayland
      # broken as of 2023-08-11
      # sirula
      slurp
      sov
      sway-contrib.grimshot
      swaybg
      # swayidle
      # swaylock
      swayr
      wayvnc
      wev
      wl-clipboard
      wlr-randr
      wob
      wofi
      # my.swaywindow
    ]
    ++ [
      # inputs.persway.packages.persway
      # i3status-rust
      # foot
    ]
    ++ work-cloud
    ++ google-cloud
    ++ postgres;

  fonts.fontconfig.enable = true;

  # modules.shell.zsh.rcFiles = ["${configDir}/emacs/aliases.zsh"];

  home.sessionPath = ["$HOME/.krew/bin"];

  home.sessionVariables = {
    # Try really hard to get QT to respect my GTK theme.
    # sessionVariables.GTK_DATA_PREFIX = ["${config.system.path}"];

    GNUPGHOME = "${config.xdg.configHome}/gnupg";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    MACHINE_STORAGE_PATH = "${config.xdg.dataHome}/docker/machine";

    QT_QPA_PLATFORMTHEME = "gnome";
    QT_STYLE_OVERRIDE = "kvantum";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";

    EDITOR = "nvim";
  };

  home.shellAliases = {
    vim = "nvim";
    v = "nvim";
    k = "kubectl";
  };

  programs.k9s.enable = true;

  systemd.user.services."maestral-daemon@maestral" = {
    Unit = {Description = "Maestral daemon for the config %i";};

    Service = {
      Type = "notify";
      ExecStart = "${nixpkgs.maestral}/bin/maestral start -f -c %i";
      ExecStop = "${nixpkgs.maestral}/bin/maestral stop";
      WatchdogSec = "30s";
    };

    Install = {WantedBy = ["default.target"];};
  };

  # programs.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

  programs.zsh.initExtra = lib.concatStringsSep "\n" [
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
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with nixpkgs.vimPlugins; [
      dracula-nvim
    ];
    extraLuaConfig = ''
      vim.cmd [[source ~/.config/nvim/init-custom.vim]]
    '';
  };

  # services = {xserver.enable = lib.mkDefault false;};

  services.mpris-proxy.enable = true;

  programs.bat.enable = true;

  programs.broot.enable = true;
  programs.broot.enableZshIntegration = true;

  programs.chromium.enable = true;

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = alacritty ] && export TERM=xterm-256color
  # '';
}
