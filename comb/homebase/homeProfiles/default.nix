# inputs.hive.findLoad {
#   inherit cell inputs;
#   block = ./.;
# }
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs emacs-overlay persway;
  inherit (inputs.nixpkgs-wayland.packages) foot;
  inherit (inputs.cells.homebase) nixosProfiles;
  styles = nixosProfiles.config;
  inherit (styles.styling) fonts fontSizes colors;
  colorscheme.colors = styles.styling.colors;

  lib = cell.lib // nixpkgs.lib // builtins;

  text = colors.withHashtag.base05;
  urgent = colors.withHashtag.base08;
  focused = colors.withHashtag.base0A;
  unfocused = colors.withHashtag.base03;

  extraConfig = "";

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
  # swayConfig = config.home.wayland.windowManager.sway.config;
  swayConfig = {
    terminal = "foot";
  };
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

  wrappedFF = nixpkgs.firefox-bin.override {
    extraNativeMessagingHosts = with nixpkgs; [passff-host tridactyl-native];
  };

  profileName = "jboyens";
  settings = {
    # Default to dark theme in DevTools panel
    "devtools.theme" = "dark";
    # Enable ETP for decent security (makes firefox containers and many
    # common security/privacy add-ons redundant).
    "browser.contentblocking.category" = "strict";
    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;
    "privacy.purge_trackers.enabled" = true;
    # Your customized toolbar settings are stored in
    # 'browser.uiCustomization.state'. This tells firefox to sync it between
    # machines. WARNING: This may not work across OSes. Since I use NixOS on
    # all the machines I use Firefox on, this is no concern to me.
    "services.sync.prefs.sync.browser.uiCustomization.state" = true;
    # Enable userContent.css and userChrome.css for our theme modules
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Stop creating ~/Downloads!
    "browser.download.dir" = "/home/jboyens/downloads";
    # Don't use site-specific zoom
    "browser.zoom.siteSpecific" = false;
    # Don't use the built-in password manager. A nixos user is more likely
    # using an external one (you are using one, right?).
    "signon.rememberSignons" = false;
    # Do not check if Firefox is the default browser
    "browser.shell.checkDefaultBrowser" = false;
    # Disable the "new tab page" feature and show a blank tab instead
    # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
    # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
    "browser.newtabpage.enabled" = false;
    "browser.newtab.url" = "about:blank";
    # Disable Activity Stream
    # https://wiki.mozilla.org/Firefox/Activity_Stream
    "browser.newtabpage.activity-stream.enabled" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    # Disable new tab tile ads & preload
    # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
    # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
    # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
    # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
    # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
    "browser.newtabpage.enhanced" = false;
    "browser.newtabpage.introShown" = true;
    "browser.newtab.preload" = false;
    "browser.newtabpage.directory.ping" = "";
    "browser.newtabpage.directory.source" = "data:text/plain,{}";
    # Reduce search engine noise in the urlbar's completion window. The
    # shortcuts and suggestions will still work, but Firefox won't clutter
    # its UI with reminders that they exist.
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.shortcuts.bookmarks" = false;
    "browser.urlbar.shortcuts.history" = false;
    "browser.urlbar.shortcuts.tabs" = false;
    "browser.urlbar.showSearchSuggestionsFirst" = false;
    "browser.urlbar.speculativeConnect.enabled" = false;
    # https://bugzilla.mozilla.org/1642623
    "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
    # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # Show whole URL in address bar
    "browser.urlbar.trimURLs" = false;
    # Disable some not so useful functionality.
    "browser.disableResetPrompt" = true; # "Looks like you haven't started Firefox in a while."
    "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour
    "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.shield-recipe-client.enabled" = false;
    "reader.parse-on-load.enabled" = false; # "reader view"

    # Security-oriented defaults
    "security.family_safety.mode" = 0;
    # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
    "security.pki.sha1_enforcement_level" = 1;
    # https://github.com/tlswg/tls13-spec/issues/1001
    "security.tls.enable_0rtt_data" = false;
    # Use Mozilla geolocation service instead of Google if given permission
    "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    "geo.provider.use_gpsd" = false;
    # https://support.mozilla.org/en-US/kb/extension-recommendations
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.htmlaboutaddons.discover.enabled" = false;
    "extensions.getAddons.showPane" = false; # uses Google Analytics
    "browser.discovery.enabled" = false;
    # Reduce File IO / SSD abuse
    # Otherwise, Firefox bombards the HD with writes. Not so nice for SSDs.
    # This forces it to write every 30 minutes, rather than 15 seconds.
    "browser.sessionstore.interval" = "1800000";
    # Disable battery API
    # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
    "dom.battery.enabled" = false;
    # Disable "beacon" asynchronous HTTP transfers (used for analytics)
    # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
    "beacon.enabled" = false;
    # Disable pinging URIs specified in HTML <a> ping= attributes
    # http://kb.mozillazine.org/Browser.send_pings
    "browser.send_pings" = false;
    # Disable gamepad API to prevent USB device enumeration
    # https://www.w3.org/TR/gamepad/
    # https://trac.torproject.org/projects/tor/ticket/13023
    "dom.gamepad.enabled" = false;
    # Don't try to guess domain names when entering an invalid domain name in URL bar
    # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
    "browser.fixup.alternate.enabled" = false;
    # Disable telemetry
    # https://wiki.mozilla.org/Platform/Features/Telemetry
    # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
    # https://wiki.mozilla.org/Telemetry
    # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
    # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
    # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
    # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
    # https://wiki.mozilla.org/Telemetry/Experiments
    # https://support.mozilla.org/en-US/questions/1197144
    # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "experiments.supported" = false;
    "experiments.enabled" = false;
    "experiments.manifest.uri" = "";
    "browser.ping-centre.telemetry" = false;
    # https://mozilla.github.io/normandy/
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "app.shield.optoutstudies.enabled" = false;
    # Disable health reports (basically more telemetry)
    # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
    # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;

    # Disable DNS-over-HTTPS
    "network.trr.mode" = 5;

    # Disable sponsored top sites
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    # Disable IPv6
    "network.dns.disableIPv6" = true;

    # no initial paint delay
    "nglayout.initialpaint.delay" = 0;

    # force webrender to use Wayland
    "gfx.webrender.compositor.force-enabled" = true;

    # Disable crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

    # Disable Form autofill
    # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
    "browser.formfill.enable" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.available" = "off";
    "extensions.formautofill.creditCards.available" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.heuristics.enabled" = false;
  };
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

      wrappedFF
      (makeDesktopItem {
        name = "firefox-private";
        desktopName = "Firefox (Private)";
        genericName = "Open a private Firefox window";
        icon = "firefox";
        exec = "${wrappedFF}/bin/firefox --private-window";
        categories = ["Network"];
      })

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
  home.file = let
    inherit profileName;

    cfgPath = ".mozilla/firefox";
  in {
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

    ".mozilla/native-messaging-hosts/tridactyl.json".source = "${nixpkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

    "${cfgPath}/profiles.ini".text = ''
      [Profile0]
      Name=default
      IsRelative=1
      Path=${profileName}.default
      Default=1

      [General]
      StartWithLastProfile=1
      Version=2
    '';

    ".config/tridactyl/tridactylrc".text = ''
      " Comment toggler for Reddit, Hacker News, and Lobste.rs
      bind ;c hint -c [class*="expand"],[class="togg"],[class="comment_folder"]

      " GitHub pull request checkout command to clipboard (only works if you're a collaborator or above)
      bind yp composite js document.getElementById("clone-help-step-1").textContent.replace("git checkout -b", "git checkout -B").replace("git pull ", "git fetch ") + "git reset --hard " + document.getElementById("clone-help-step-1").textContent.split(" ")[3].replace("-","/") | yank

      " Git{Hub,Lab} git clone via SSH yank
      bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank

      " Handy multiwindow/multitasking binds
      bind gd tabdetach
      bind gD composite tabduplicate | tabdetach

      " Add helper commands that Mozillians think make Firefox irredeemably insecure
      command fixamo_quiet jsb tri.excmds.setpref("privacy.resistFingerprinting.block_mozAddonManager", "true").then(tri.excmds.setpref("extensions.webextensions.restrictedDomains", '""'))
      command fixamo js tri.excmds.setpref("privacy.resistFingerprinting.block_mozAddonManager", "true").then(tri.excmds.setpref("extensions.webextensions.restrictedDomains", '""').then(tri.excmds.fillcmdline_tmp(3000, "Permissions added to user.js. Please restart Firefox to make them take affect.")))

      " Make Tridactyl work on more sites at the expense of some security
      set csp clobber
      fixamo_quiet

      set newtab about:blank

      " Allow Ctrl-a to select all in the commandline
      unbind --mode=ex <C-a>

      " Allow Ctrl-c to copy in the commandline
      unbind --mode=ex <C-c>

      " Sane hinting mode
      set hintfiltermode vimperator-reflow
      " set hintnames numeric

      bind ^https://duckduckgo.com f hint -Jc[data-testid=result]
      bind ^https://duckduckgo.com F hint -Jbc[data-testid=result]

      set theme dark

      " Defaults to 300ms but I'm a 'move fast and close the wrong tabs' kinda chap
      set hintdelay 100

      bind J tabnext
      bind K tabprev

      bind O fillcmdline tabopen

      bind zp js window.location.href = 'org-protocol://roam-ref?template=r&ref=' + encodeURIComponent(location.href) + '&title=' + encodeURIComponent(document.title)
    '';

    "${cfgPath}/${profileName}.default/user.js" = {
      text = ''
        ${lib.concatStrings (lib.mapAttrsToList (name: value: ''
            user_pref("${name}", ${builtins.toJSON value});
          '')
          settings)}
        ${extraConfig}
      '';
    };

    "${cfgPath}/${profileName}.default/chrome/userChrome.css" = {
      text = "";
    };

    "${cfgPath}/${profileName}.default/chrome/userContent.css" = {
      text = "";
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

  programs.swaylock = let
    inside = colors.base01-hex;
    outside = colors.base01-hex;
    ring = colors.base05-hex;
    text = colors.base05-hex;
    positive = colors.base0B-hex;
    negative = colors.base08-hex;
  in {
    enable = true;
    settings = {
      color = outside;
      scaling = "fill";
      inside-color = inside;
      inside-clear-color = inside;
      inside-caps-lock-color = inside;
      inside-ver-color = inside;
      inside-wrong-color = inside;
      key-hl-color = positive;
      layout-bg-color = inside;
      layout-border-color = ring;
      layout-text-color = text;
      line-uses-inside = true;
      ring-color = ring;
      ring-clear-color = negative;
      ring-caps-lock-color = ring;
      ring-ver-color = positive;
      ring-wrong-color = negative;
      separator-color = "00000000";
      text-color = text;
      text-clear-color = text;
      text-caps-lock-color = text;
      text-ver-color = text;
      text-wrong-color = text;

      # image = l.toString styles.styling.image;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = null; # must be managed at the NixOS level
    systemd.enable = true;
    swaynag.enable = true;

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_WEBRENDER=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
      export NIXOS_OZONE_WL=1
      export XCURSOR_PATH=${nixpkgs.dracula-icon-theme}/share/icons
      export XCURSOR_THEME=Dracula
      export WLR_DRM_NO_MODIFIERS=1
    '';

    config = let
      super = "Mod4";
      alt = "Mod1";
      control = "Ctrl";
      shift = "Shift";
      hyper = "${control}+${alt}+${super}+${shift}";
      meh = "${control}+${alt}+${shift}";
      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in {
      terminal = "foot";

      window.titlebar = false;
      floating.titlebar = false;

      # FIXME
      bars = [
        {
          fonts = {
            names = ["Iosevka Aile" "Font Awesome 5 Pro"];
            size = 12.0;
          };
          position = "bottom";
          statusCommand = "i3status-rs ~/.config/i3status-rust/config.toml";
          colors = {
            background = "#282936";
            statusline = "#e9e9f4";
            focusedWorkspace = {
              border = "#3a3c4e";
              background = "#3a3c4e";
              text = "#e9e9f4";
            };
            activeWorkspace = {
              border = "#3a3c4e";
              background = "#3a3c4e";
              text = "#e9e9f4";
            };
            inactiveWorkspace = {
              border = "#282936";
              background = "#282936";
              text = "#e9e9f4";
            };
            urgentWorkspace = {
              border = "#ea51b2";
              background = "#ea51b2";
              text = "#e9e9f4";
            };
          };
        }
      ];

      modifier = "Mod4";
      keybindings = lib.mkOptionDefault {
        "${super}+Bracketleft" = "workspace prev";
        "${super}+Bracketright" = "workspace next";
        "${super}+${control}+Return" = "exec ${swayConfig.terminal}";
        "${super}+Return" = ''
          exec ${swayConfig.terminal} bash -c "(tmux ls | grep -qEv 'attached|scratch' && tmux at) || tmux"'';
        "${super}+${control}+Slash" = "exec firefox";
        "${super}+q" = "kill";
        # "${super}+space" = "exec $DOTFILES/bin/appmenu";
        "${super}+space" = "exec $DOTFILES/bin/rofi/appmenu";
        # "${super}+Tab" = "exec swayr switch-window";
        # "${super}+Tab" = "exec $DOTFILES/bin/rofi/windowmenu";
        "${super}+p" = "exec $DOTFILES/bin/rofi/bwmenu";
        "${super}+Shift+p" = "exec $DOTFILES/bin/rofi/bwmenu -r";
        "${super}+Shift+c" = "reload";
        "${super}+${control}+${shift}+Escape" = "reload";
        "${super}+question" = "exec $DOTFILES/bin/remontoire-toggle";
        "${super}+${alt}+Escape" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${super}+Slash" = "exec $DOTFILES/bin/rofi/filemenu -x";
        "${super}+Backslash" = "exec $DOTFILES/bin/rofi/bwmenu";
        "${super}+Grave" = "exec $DOTFILES/bin/scratch";
        "${super}+${shift}+Grave" = "exec emacsclient -n -c -e '(doom/open-scratch-buffer)'";
        "${super}+e" = "exec emacsclient -e '(emacs-everywhere)'";
        "${super}+t" = "exec emacsclient -n -c ~/Documents/org-mode/todo.org && $DOTFILES/bin/activate emacs";
        "${super}+n" = "exec emacsclient -n -c ~/Documents/org-mode/notes.org && $DOTFILES/bin/activate emacs";
        "${super}+d" = "exec emacsclient -n -c -e '(org-roam-dailies-goto-today)' && $DOTFILES/bin/activate emacs";
        "${super}+${control}+t" = "exec $XDG_CONFIG_HOME/emacs/bin/org-capture -k t";
        "${super}+${control}+n" = "exec $XDG_CONFIG_HOME/emacs/bin/org-capture -k n";
        "${super}+m" = "exec emacsclient -c -n -e '(=mu4e)' && $DOTFILES/bin/activate emacs";
        "${hyper}+e" = "$DOTFILES/bin/activate emacs";
        "${hyper}+f" = "$DOTFILES/bin/activate firefox";
        "${hyper}+s" = "$DOTFILES/bin/activate slack";
        "${hyper}+z" = "$DOTFILES/bin/activate zoom zoom-us";

        "${super}+${left}" = "focus left";
        "${super}+${down}" = "focus down";
        "${super}+${up}" = "focus up";
        "${super}+${right}" = "focus right";

        "${super}+${control}+${left}" = "focus output left";
        "${super}+${control}+${down}" = "focus output down";
        "${super}+${control}+${up}" = "focus output up";
        "${super}+${control}+${right}" = "focus output right";

        "${super}+${shift}+${left}" = "move left";
        "${super}+${shift}+${down}" = "move down";
        "${super}+${shift}+${up}" = "move up";
        "${super}+${shift}+${right}" = "move right";

        "${super}+${shift}+${control}+${left}" = "move output left";
        "${super}+${shift}+${control}+${down}" = "move output down";
        "${super}+${shift}+${control}+${up}" = "move output up";
        "${super}+${shift}+${control}+${right}" = "move output right";

        "${meh}+${left}" = "move workspace to output left";
        "${meh}+${down}" = "move workspace to output down";
        "${meh}+${up}" = "move workspace to output up";
        "${meh}+${right}" = "move workspace to output right";

        "${super}+w" = "exec swayr toggle-tab-shuffle-tile-workspace include-floating";
        #"${super}+e" = "layout toggle split";

        "${super}+f" = "floating toggle";
        "${super}+${control}+f" = "fullscreen";
        "${super}+a" = "focus parent";
        "${super}+minus" = "scratchpad show";
        "${super}+${shift}+minus" = "move scratchpad";

        "${super}+Left" = "resize grow width 40 px";
        "${super}+Down" = "resize grow height 40 px";
        "${super}+Up" = "resize grow height 40 px";
        "${super}+Right" = "resize grow width 40 px";
        "${super}+${control}+Left" = "resize shrink width 40 px";
        "${super}+${control}+Down" = "resize shrink height 40 px";
        "${super}+${control}+Up" = "resize shrink height 40 px";
        "${super}+${control}+Right" = "resize shrink width 40 px";

        "XF86AudioPlay" = "exec ${nixpkgs.playerctl}/bin/playerctl play";
        "XF86AudioPause" = "exec ${nixpkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioStop" = "exec ${nixpkgs.playerctl}/bin/playerctl stop";
        "XF86AudioPrev" = "exec ${nixpkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext" = "exec ${nixpkgs.playerctl}/bin/playerctl next";

        "XF86MonBrightnessUp" = "exec ${nixpkgs.brightnessctl}/bin/brightness_ctl set +10% && $DOTFILES/bin/brightnessctl_perc > $SWAYSOCK.wob";
        "XF86MonBrightnessDown" = "exec ${nixpkgs.brightnessctl}/bin/brightness_ctl set 10%- && $DOTFILES/bin/brightnessctl_perc > $SWAYSOCK.wob";

        "XF86AudioRaiseVolume" = "exec pamixer -ui 2 && pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioLowerVolume" = "exec pamixer -ud 2 && pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioMute" = "exec pamixer -t && if [ $(pamixer --get-mute) == true ]; then; echo 0; else; pamixer --get-volume; fi > $SWAYSOCK.wob";

        "${super}+r" = ''mode "resize"'';

        "--no-repeat --release ${hyper}+m" = "exec $DOTFILES/bin/mute-huddle";

        "${super}+Control+Shift+space" = "exec persway stack-main-rotate-next";
        "${super}+Shift+Tab" = "exec persway stack-focus-prev";
        "${super}+Tab" = "exec persway stack-focus-next";
        "${super}+c" = "exec persway change-layout stack-main --size 70 --stack-layout tiled";
        "${super}+Control+space" = "exec persway stack-swap-main";
        # bindsym Mod4+v exec ${inputs.persway.persway} change-layout manual
        # bindsym Mod4+x exec ${inputs.persway.persway} change-layout stack-main --size 70
        # bindsym Mod4+z exec ${inputs.persway.persway} change-layout spiral

        #     floating_modifier $super normal
      };
      modes = {
        resize = {
          "${left}" = "resize shrink width 10px";
          "${down}" = "resize grow height 10px";
          "${up}" = "resize shrink height 10px";
          "${right}" = "resize grow width 10px";

          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";

          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
        };
      };

      colors = let
        inherit fonts;
        background = colors.withHashtag.base00;
        indicator = colors.withHashtag.base0B;
      in {
        inherit background;
        urgent = {
          inherit background indicator text;
          border = urgent;
          childBorder = urgent;
        };
        focused = {
          inherit background indicator text;
          border = focused;
          childBorder = focused;
        };
        focusedInactive = {
          inherit background indicator text;
          border = unfocused;
          childBorder = unfocused;
        };
        unfocused = {
          inherit background indicator text;
          border = unfocused;
          childBorder = unfocused;
        };
        placeholder = {
          inherit background indicator text;
          border = unfocused;
          childBorder = unfocused;
        };
      };

      window = {
        commands = [
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {app_id = "scratch";};
          }
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {class = "scratch";};
          }
          {
            command = "floating true,,resize set width 940 height 760,,border pixel 2";
            criteria = {title = "doom-capture";};
          }
          {
            command = "floating true,,resize set width 1200 height 800,,border pixel 2,,move position center";
            criteria = {app_id = "pavucontrol";};
          }
          {
            command = "floating true,,move position 50ppt 100ppt";
            criteria = {title = "Firefox - Sharing Indicator";};
          }
          {
            command = "floating true";
            criteria = {class = "floating";};
          }
          {
            command = "floating true,,sticky true";
            criteria = {title = "Zoom Meeting";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "dialog";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "utility";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "toolbar";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "splash";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "dropdown_menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "popup_menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "tooltip";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "notification";};
          }
          {
            command = "shortcuts_inhibitor disable";
            criteria = {app_id = "^chrome-.*";};
          }
          {
            command = "floating enable,,move to position center,,resize set 800 600,,border pixel 3";
            criteria = {title = "^Emacs Everywhere.*";};
          }
        ];
      };

      focus = {
        followMouse = true;
        mouseWarping = "container";
        newWindow = "smart";
      };

      gaps = {
        inner = 8;
        smartGaps = true;
      };

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_model = "dell";
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Touchpad" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Mouse" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      output = {
        "*" = {bg = "/home/jboyens/Downloads/vhs.png fill";};

        eDP-1 = {
          mode = "1920x1080@60Hz";
          position = "6940,2160";
        };

        "LG Electronics LG Ultra HD 0x00011A21" = {
          mode = "3840x2160@60Hz";
          position = "0,0";
          scale = "1.0";
        };

        "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E" = {
          mode = "3840x2160@60Hz";
          position = "3840,0";
          scale = "1.0";
        };
      };

      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "1";
        }
        {
          output = "LG Electronics LG Ultra HD 0x00011A21";
          workspace = "2";
        }
        {
          output = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
          workspace = "3";
        }
      ];

      startup = [
        {
          command = "$DOTFILES/bin/laptop.sh";
          always = true;
        }
        {
          command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${nixpkgs.wob}/bin/wob";
          always = false;
        }
        {
          command = "persway daemon -w -d stack_main";
          always = false;
        }
        {
          command = "${nixpkgs.swayr}/bin/swayrd";
          always = false;
        }
        {
          command = "${nixpkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G";
          always = false;
        }
      ];
    };
  };

  services.mako = let
    iconPath = let
      basePaths = [
        "/run/current-system/sw"
        # inputs.home-manager.config.home.profileDirectory
        "/home/jboyens/.nix-profile"
        "/etc/profiles/per-user/jboyens"
      ];
      themes = ["Dracula" "Adwaita" "hicolor"];
      mkPath = {
        basePath,
        theme,
      }: "${basePath}/share/icons/${theme}";
    in
      lib.concatMapStringsSep ":" mkPath (lib.cartesianProductOfSets {
        basePath = basePaths;
        theme = themes;
      });
  in {
    inherit iconPath;

    enable = true;
    actions = true;
    anchor = "top-right";
    borderRadius = 2;
    borderSize = 1;
    defaultTimeout = 0;
    height = 1000;
    icons = true;
    ignoreTimeout = false;
    margin = "4,26";
    markup = true;
    maxVisible = -1;
    padding = "20,16";
    width = 440;

    backgroundColor = colors.withHashtag.base00;
    borderColor = colors.withHashtag.base0D;
    textColor = colors.withHashtag.base05;
    progressColor = "over ${colors.withHashtag.base02}";
    font = "${fonts.sansSerif.name} ${toString fontSizes.popups}";

    extraConfig = ''
      [urgency=low]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base0A}

      [urgency=high]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base08}

      [app-name="Slack"]
      group-by=summary
      default-timeout=15000
    '';
  };

  services.mpris-proxy.enable = true;

  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 600;
        command = "${nixpkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 1200;
        command = "${nixpkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${nixpkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${nixpkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };

  services.kanshi = {
    enable = true;
    profiles = {
      Home = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "6940,2160";
            scale = 1.0;
          }
          {
            criteria = "LG Electronics LG Ultra HD 0x00001B21";
            mode = "3840x2160@60Hz";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
            mode = "3840x2160@60Hz";
            position = "3840,0";
            scale = 1.0;
          }
        ];
      };
      Mobile = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "6940,2160";
            scale = 1.0;
          }
        ];
      };
    };
  };

  services.wlsunset = {
    enable = true;
    latitude = "47.6062";
    longitude = "-122.3321";
  };

  gtk = {
    enable = true;

    theme = {
      # package = nixpkgs.adw-gtk3;
      # name = "adw-gtk3";
      package = nixpkgs.dracula-theme;
      name = "Dracula";
    };
  };

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  # '';

  # xst-256color isn't supported over ssh, so revert to a known one
  # modules.shell.zsh.rcInit = ''
  #   [ "$TERM" = alacritty ] && export TERM=xterm-256color
  # '';

  programs.foot = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.foot;
    settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
        font = "${fonts.monospace.name}:size=${toString fontSizes.terminal}";
      };

      colors = {
        foreground = colors.base05-hex;
        background = colors.base00-hex;
        regular0 = colors.base00-hex;
        regular1 = colors.base08-hex;
        regular2 = colors.base0B-hex;
        regular3 = colors.base0A-hex;
        regular4 = colors.base0D-hex;
        regular5 = colors.base0E-hex;
        regular6 = colors.base0C-hex;
        regular7 = colors.base05-hex;
        bright0 = colors.base03-hex;
        bright1 = colors.base08-hex;
        bright2 = colors.base0B-hex;
        bright3 = colors.base0A-hex;
        bright4 = colors.base0D-hex;
        bright5 = colors.base0E-hex;
        bright6 = colors.base0C-hex;
        bright7 = colors.base07-hex;
      };
      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
      };
    };
  };
}
