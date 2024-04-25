{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs;

  # myEmacsPkg = pkgs.emacs-unstable-pgtk;
  myEmacsPkg = pkgs.emacs29-pgtk;
  # myEmacsPkg = pkgs.enableDebugging pkgs.emacs-unstable;
  # myEmacsPkg = pkgs.emacs;

  myEmacs =
    (inputs.nixpkgs.pkgs.emacsPackagesFor myEmacsPkg).emacsWithPackages
    (epkgs: [
      epkgs.vterm
      epkgs.parinfer-rust-mode
      epkgs.treesit-grammars.with-all-grammars
      epkgs.mu4e
    ]);
in {
  home.sessionPath = ["${config.xdg.configHome}/emacs/bin"];

  systemd.user.services.org-mode-sync = {
    Unit = {
      Description = "git-sync for org-mode-store";
      ConditionPathExists = "%h/Documents/org-mode";
      After = "network.target";
    };

    Service = {
      Environment = "PATH=${pkgs.git-sync}/bin:${pkgs.git}/bin:$PATH";
      WorkingDirectory = "/home/jboyens/Documents/org-mode/";
      ExecStart = "${pkgs.git-sync}/bin/git-sync-on-inotify";
      Restart = "always";
      RestartSec = "30";
    };

    Install = {WantedBy = ["default.target"];};
  };

  programs.zsh.initExtra = ''
    ### emacs aliases
    e()     { emacsclient -c -n -a 'emacs' "$@" }
    ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
    eman()  { e --eval "(switch-to-buffer (man \"$1\"))"; }
    ekill() { emacsclient --eval '(kill-emacs)'; }
    ### end aliases
  '';

  home.packages = with pkgs; [
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
    # texliveFull
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
    nixfmt-rfc-style
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
    gomodifytags
    gotests
    gore
    gopls

    # :lang markdown
    discount
    # python311Packages.grip

    # :lang web
    html-tidy

    pandoc

    emacs-all-the-icons-fonts
  ];
}
