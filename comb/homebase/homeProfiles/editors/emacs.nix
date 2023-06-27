{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs emacs-overlay;
  inherit (cell) lib;

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
  myEmacsPkg = emacs-overlay.packages.emacs-unstable-pgtk;

  myEmacs = (nixpkgs.emacsPackagesFor myEmacsPkg).emacsWithPackages (epkgs: [
    epkgs.vterm
    epkgs.parinfer-rust-mode
    epkgs.treesit-grammars.with-all-grammars
  ]);
in {
  home.packages = with nixpkgs; [
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
    languagetool
    # :tools editorconfig
    editorconfig-core-c # per-project style config
    # :tools lookup & :lang org +roam
    sqlite
    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium
    # :lang beancount
    beancount
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

    mpc_cli

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
  ];

  home.sessionPath = ["$XDG_CONFIG_HOME/emacs/bin"];

  # modules.shell.zsh.rcFiles = ["${configDir}/emacs/aliases.zsh"];

  fonts.fontconfig.enable = true;
}
