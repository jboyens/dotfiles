# inputs.hive.findLoad {
#   inherit cell inputs;
#   block = ./.;
# }
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs emacs-overlay;
  inherit (inputs.cells.homebase) nixosProfiles;
  styles = nixosProfiles.config;
  inherit (styles.styling) colors;

  lib = cell.lib // nixpkgs.lib // builtins;

  # fonts = {
  #   names = [styles.styling.fonts.sansSerif.name];
  #   size = styles.styling.fontSizes.desktop + 0.0;
  # };

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
    open-policy-agent
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
    cloud-sql-proxy
  ];

  postgres = with nixpkgs; [
    postgresql
    pgcenter
  ];
  # https://github.com/nix-community/emacs-overlay/issues/312
  # myEmacs = pkgs.emacsUnstablePgtk.overrideAttrs (prev: {
  #   postFixup = builtins.replaceStrings ["/bin/emacs"] ["/bin/.emacs-*-wrapped"] prev.postFixup;
  # });
  # myEmacs = pkgs.emacsUnstablePgtk;
  # myEmacs = (pkgs.emacsGit.override {
  #   withSQLite3 = true;
  #   withWebP = true;
  #   withPgtk = true;
  # });
  myEmacsPkg = emacs-overlay.packages.emacs-unstable-pgtk.overrideAttrs (prev: {
    passthru = prev.passthru // {treeSitter = true;};
  });

  myEmacs = (nixpkgs.emacsPackagesFor myEmacsPkg).emacsWithPackages (epkgs: [
    epkgs.vterm
    epkgs.parinfer-rust-mode
    epkgs.treesit-grammars.with-all-grammars
  ]);

  my = inputs.cells.homebase.packages;
  inherit (my) pizauth;
  inherit (my) isync-oauth2;
in {
  home.packages = with nixpkgs;
    [
      # ripgrep
      sudo
      bottom
      fzf
      exa

      clang
      (lib.hiPrio gcc)
      bear
      gdb
      cmake
      llvmPackages.libcxx

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

      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      # 29 + pgtk + native-comp
      myEmacs

      ## Doom dependencies
      # git
      (ripgrep.override {withPCRE2 = true;})
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      # (mkIf (config.programs.gnupg.agent.enable)
      #   pinentry_emacs)   # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression
      python3 # for treemacs

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      # :checkers grammar
      # languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      # beancount
      # fava
      # :lang rust
      rustfmt
      rust-analyzer
      (makeDesktopItem {
        name = "org-protocol";
        desktopName = "org-protocol";
        exec = "${myEmacs}/bin/emacsclient -n %u";
        type = "Application";
        categories = ["System"];
        mimeTypes = ["x-scheme-handler/org-protocol"];
      })
      # :lang nix
      nixfmt
      # :lang sh
      shellcheck
      shfmt
      # :lang org
      graphviz
      maim

      # (mu.override { emacs = myEmacs; })

      # :lang terraform
      terraform-ls

      # :lang go
      gocode
      gomodifytags
      gotests
      gore

      # :lang markdown
      discount
      python311Packages.grip

      # :lang web
      html-tidy

      pandoc

      emacs-all-the-icons-fonts

      offlineimap
      # don't install mu4e here
      mu
      imapfilter
      isync-oauth2
      msmtp
      pizauth
      age
      (writeScriptBin "mu-reindex" ''
        if [ -f /tmp/mu4e_lock ]; then
          ${coreutils-full}/bin/touch /tmp/mu_reindex_now
        else
          ${mu}/bin/mu index --lazy-check
        fi
      '')

      easyeffects

      editorconfig-core-c
      neovim-unwrapped

      bitwarden

      maestral
      maestral-gui

      element-desktop
      signal-desktop
      slack
      zoom-us
      (makeDesktopItem {
        name = "Google Meet";
        desktopName = "Google Meet";
        genericName = "Open Google Meet";
        icon = "chrome-kjgfgldnnfoeklkmfkjfagphfepbbdan-Default";
        exec = "google-chrome-stable \"--profile-directory=Default\" --app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan --ozone-platform-hint=auto";
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

      gitAndTools.git-annex
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      gitAndTools.git-crypt
      gitAndTools.git-sync
      gitAndTools.git-delete-merged-branches

      cell.packages.gnupg

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
      swayidle
      swaylock
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
      inputs.persway.packages.persway
      inputs.nixpkgs-wayland.packages.i3status-rust
      inputs.nixpkgs-wayland.packages.foot
    ]
    ++ work-cloud
    ++ google-cloud
    ++ postgres;

  fonts.fontconfig.enable = true;

  # modules.shell.zsh.rcFiles = ["${configDir}/emacs/aliases.zsh"];

  home.sessionPath = [
    "$XDG_CONFIG_HOME/emacs/bin"
    "$HOME/.krew/bin"
    "$XDG_CONFIG_HOME/dotfiles/bin"
    "$XDG_CONFIG_HOME/emacs/bin"
    "$TMUXIFIER/bin"
  ];

  systemd.user = {
    startServices = "sd-switch";
    services = {
      pizauth = {
        Unit = {
          Description = "OAuth2 Service Daemon";
          ConditionPathExists = "%h/.config/pizauth.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${nixpkgs.libnotify}/bin:${nixpkgs.age}/bin:$PATH";
          ExecStart = "${pizauth}/bin/pizauth server -dvc %h/.config/pizauth.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      "goimapnotify@flexe" = {
        Unit = {
          Description = "IMAP notifier using IDLE, golang version.";
          ConditionPathExists = "%h/.config/imapnotify/%I/notify.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${isync-oauth2}/bin:${nixpkgs.mu}/bin:${pizauth}/bin:$PATH";
          ExecStart = "${nixpkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      "goimapnotify@fooninja" = {
        Unit = {
          Description = "IMAP notifier using IDLE, golang version.";
          ConditionPathExists = "%h/.config/imapnotify/%I/notify.conf";
          After = "network.target";
        };

        Service = {
          Environment = "PATH=${isync-oauth2}/bin:${nixpkgs.mu}/bin:${pizauth}/bin:$PATH";
          ExecStart = "${nixpkgs.goimapnotify}/bin/goimapnotify -conf %h/.config/imapnotify/%I/notify.conf";
          Restart = "always";
          RestartSec = "30";
        };

        Install = {WantedBy = ["default.target"];};
      };

      mbsync = {
        Unit = {
          Description = "mbsync service, sync all mail";
          ConditionPathExists = "%h/.mbsyncrc";
          Documentation = "man:mbsync(1)";
        };

        Service = {
          Environment = "PATH=${pizauth}/bin:$PATH";
          Type = "oneshot";
          ExecStart = "${isync-oauth2}/bin/mbsync -c %h/.mbsyncrc --all";
        };
      };
    };

    timers = {
      mbsync = {
        Unit = {
          Description = "call mbsync on all accounts every 15 m";
          ConditionPathExists = "%h/.mbsyncrc";
        };

        Timer = {
          Unit = "mbsync.service";
          OnCalendar = "*:0/15";
          Persistent = "true";
        };

        Install = {WantedBy = ["default.target"];};
      };
    };
  };

  # Prevent auto-creation of ~/Desktop. The trailing slash is necessary; see
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1082717
  home.sessionVariables.XDG_DESKTOP_DIR = "$HOME/";

  # Use a stable profile name so we can target it in themes
  home.file = {
    ".config/zsh/completions/" = {
      source = ./_zsh/completions;
      recursive = true;
    };

    ".config/zsh/keybinds.zsh" = {
      source = ./_zsh/keybinds.zsh;
    };

    ".config/zsh/aliases.zsh" = {
      source = ./_zsh/aliases.zsh;
    };

    ".config/zsh/completion.zsh" = {
      source = ./_zsh/completion.zsh;
    };

    ".config/zsh/config.zsh" = {
      source = ./_zsh/config.zsh;
    };

    ".config/rofi/themes/base16.rasi" = {
      text = ''
        @import "themes/base16-base.rasi"

        ${builtins.readFile ./overrides.rasi}
      '';
    };
    ".config/rofi/themes/base16-base.rasi" = {
      text = builtins.readFile (colors inputs.base16-rofi);
    };
    ".config/rofi/theme" = {
      source = ./_theme;
      recursive = true;
    };

    ".config/tmux" = {
      source = ./_tmux;
      recursive = true;
    };
    ".config/tmux/extraInit" = {
      text = ''
        #!/usr/bin/env bash
        # This file is auto-generated by nixos, don't edit by hand!
        tmux run-shell '${nixpkgs.tmuxPlugins.copycat}/share/tmux-plugins/copycat/copycat.tmux'
        tmux run-shell '${nixpkgs.tmuxPlugins.prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux'
        tmux run-shell '${nixpkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux'
        tmux run-shell '${nixpkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux'
      '';
      executable = true;
    };
  };

  home.sessionVariables = {
    # Try really hard to get QT to respect my GTK theme.
    # sessionVariables.GTK_DATA_PREFIX = ["${config.system.path}"];
    QT_QPA_PLATFORMTHEME = "gnome";
    QT_STYLE_OVERRIDE = "kvantum";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
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

  programs.rofi = {
    enable = true;
    cycle = true;
    package = nixpkgs.rofi-wayland.override {
      plugins = with nixpkgs; [
        rofi-calc
        rofi-emoji
        rofi-file-browser
        rofi-top
      ];
    };
    extraConfig = {
      icon-theme = "Dracula";
      disable-history = false;

      kb-accept-entry = "Return,Control+m,KP_Enter";
      kb-row-down = "Down,Control+n,Control+j";
      kb-row-up = "Up,Control+p,Control+k";
      kb-remove-to-eol = "";
    };
    theme = "base16";
    terminal = "foot";
  };

  programs.git = {
    enable = true;
    package = nixpkgs.gitAndTools.gitFull;
    aliases = {
      unadd = "reset HEAD";
      ranked-authors = "!git authors | sort | uniq -c | sort -n";
      emails = ''!git log --format="%aE" | sort -u'';
      email-domains = ''!git log --format="%aE" | awk -F'@' '{print $2}' | sort -u'';
      st = "status";

      up = "push";
      down = "pull";

      cdg = "cd `git rev-parse --show-toplevel`";
      git = "noglob git";
      ga = "git add";
      gap = "git add --patch";
      gb = "git branch -av";
      gop = "git open";
      gbl = "git blame";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gcf = "git commit --fixup";
      gcl = "git clone";
      gco = "git checkout";
      gcoo = "git checkout --";
      gf = "git fetch";
      gi = "git init";
      gl = ''git log --graph --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'';
      gll = ''git log --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'';
      gL = "gl --stat";
      gp = "git push";
      gpl = "git pull --rebase --autostash";
      gs = "git status --short .";
      gss = "git status";
      gst = "git stash";
      gr = "git reset HEAD";
      gv = "git rev-parse";
    };

    attributes = [
      "*.c     diff=cpp"
      "*.h     diff=cpp"
      "*.c++   diff=cpp"
      "*.h++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.hpp   diff=cpp"
      "*.cc    diff=cpp"
      "*.hh    diff=cpp"
      "*.cs    diff=csharp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.ex    diff=elixir"
      "*.exs   diff=elixir"
      "*.go    diff=golang"
      "*.php   diff=php"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rb    diff=ruby"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.lisp  diff=lisp"
      "*.el    diff=lisp"
      "*.org   diff=org"
    ];

    diff-so-fancy.enable = true;

    ignores = [
      "*~"
      "*.*~"
      "#*"
      ".#*"
      "*.swp"
      ".*.sw[a-z]"
      "*.un~"
      ".netrwhist"
      ".DS_Store?"
      ".DS_Store"
      ".CFUserTextEncoding"
      ".Trash"
      ".Xauthority"
      "thumbs.db"
      "Thumbs.db"
      "Icon?"
      ".ccls-cache/"
      ".sass-cache/"
      "__pycache__/"
      "*.class"
      "*.exe"
      "*.o"
      "*.pyc"
      "*.elc"
    ];

    lfs.enable = true;

    signing.key = "785C9CAE60A7B23F";
    signing.signByDefault = true;

    userEmail = "jr.boyens@flexe.com";
    userName = "JR Boyens";

    extraConfig = {
      core.whitespace = "trailing-space";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";

      diff.algorithm = "histogram";
      diff.lisp.xfuncname = "^(((;;;+ )|\\(|([ 	]+\\(((cl-|el-patch-)?def(un|var|macro|method|custom)|gb/))).*)$";
      diff.org.xfuncname = "^(\\*+ +.*)$";

      github.user = "jboyens";

      gitlab = {
        "gitlab.com/api".user = "jr.boyens";
        "gitlab.com/api/v4".user = "jr.boyens";
      };

      init.defaultBranch = "master";

      protocol.version = 2;

      pull = {
        rebase = true;
        twohead = "ort";
      };

      push = {
        default = "current";
        gpgSign = "if-asked";
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      rerere.enabled = true;

      url."https://github.com/".insteadOf = "gh:";
      url."git@github.com:".insteadOf = "ssh+gh:";
      url."git@github.com:jboyens/".insteadOf = "gh:/";
      url."https://gist.github.com/".insteadOf = "gist:";
      url."https://gitlab.com/".insteadOf = "gl:";
      url."git@gitlab.com:".insteadOf = "ssh+gl:";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "/home/jboyens/.config/gnupg";
    package = cell.packages.gnupg;
  };

  services.gpg-agent = {
    # homedir = "$XDG_CONFIG_HOME/gnupg";
    enable = true;
    enableExtraSocket = true;
    defaultCacheTtl = 3600; # 1hr
    enableZshIntegration = true;
    extraConfig = ''
      allow-loopback-pinentry
    '';

    pinentryFlavor = "gtk2";
  };

  # programs.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

  home.sessionVariables = {
    TMUX_HOME = "$XDG_CONFIG_HOME/tmux";
    TMUXIFIER = "$XDG_DATA_HOME/tmuxifier";
    TMUXIFIER_LAYOUT_PATH = "$XDG_DATA_HOME/tmuxifier";
  };

  programs.zsh = {
    enable = true;
    # i'll init completion thankyouverymuch
    enableCompletion = false;
    dotDir = ".config/zsh";

    envExtra = builtins.readFile ./_zsh/.zshenv;
    initExtraBeforeCompInit = builtins.readFile ./_zsh/.zshrc;
    initExtra = with builtins;
      lib.concatStringsSep "\n" [
        ''
          ### emacs aliases
          e()     { emacsclient -c -n -a 'emacs' "$@" }
          ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
          eman()  { e --eval "(switch-to-buffer (man \"$1\"))"; }
          ekill() { emacsclient --eval '(kill-emacs)'; }
          ### end aliases
        ''

        ''
          ### git aliases
          g() { [[ $# = 0 ]] && git status --short . || git $*; }

          # fzf
          if (( $+commands[fzf] )); then
            __git_log () {
              # format str implies:
              #  --abbrev-commit
              #  --decorate
              git log \
                --color=always \
                --graph \
                --all \
                --date=short \
                --format="%C(bold blue)%h%C(reset) %C(green)%ad%C(reset) | %C(white)%s %C(red)[%an] %C(bold yellow)%d"
            }

            _fzf_complete_git() {
              ARGS="$@"

              # these are commands I commonly call on commit hashes.
              # cp->cherry-pick, co->checkout

              if [[ $ARGS == 'git cp'* || \
                    $ARGS == 'git cherry-pick'* || \
                    $ARGS == 'git co'* || \
                    $ARGS == 'git checkout'* || \
                    $ARGS == 'git reset'* || \
                    $ARGS == 'git show'* || \
                    $ARGS == 'git log'* ]]; then
                _fzf_complete "--reverse --multi" "$@" < <(__git_log)
              else
                eval "zle ''${fzf_default_completion:-expand-or-complete}"
              fi
            }

            _fzf_complete_git_post() {
              sed -e 's/^[^a-z0-9]*//' | awk '{print $1}'
            }
          fi
          ### end aliases

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

        (readFile ./_zsh/prompt.zsh)
        ''
          ### tmux aliases
          alias ta='tmux attach'
          alias tl='tmux ls'

          if [[ -n $TMUX ]]; then # From inside tmux
            alias tf='tmux find-window'
            # Detach all other clients to this session
            alias mine='tmux detach -a'
            # Send command to other tmux window
            tt() {
              tmux send-keys -t .+ C-u && \
                tmux set-buffer "$*" && \
                tmux paste-buffer -t .+ && \
                tmux send-keys -t .+ Enter;
            }
            # Create new session (from inside one)
            tn() {
              local name="''${1:-`basename $PWD`}"
              TMUX= tmux new-session -d -s "$name"
              tmux switch-client -t "$name"
              tmux display-message "Session #S created"
            }
          else # From outside tmux
            # Start grouped session so I can be in two different windows in one session
            tdup() { tmux new-session -t "''${1:-`tmux display-message -p '#S'`}"; }
          fi
          ### end tmux
        ''
      ];

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$ZDOTDIR/.zhistory";
      save = 100000;
      size = 100000;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  # services = {xserver.enable = lib.mkDefault false;};

  services.mpris-proxy.enable = true;

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  # '';

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = alacritty ] && export TERM=xterm-256color
  # '';
}
