# Emacs is my main driver. I'm the author of Doom Emacs
# https://github.com/hlissner/doom-emacs. This module sets it up to meet my
# particular Doomy needs.

{ config, lib, pkgs, ... }:

let
  emacsUnstable = (pkgs.emacsGit.override { srcRepo = true; }).overrideAttrs(old: {
    name = "emacs-git-27.0.90";
    version = "27.0.90";
    src = pkgs.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "8944310d7c9e259c9611ff2f0004c3176eb0ddab";
      sha256 = "0a8c48zq86z296hi8cdi53pmcnfr3013nnvws9vxbpz9ipxrngll";
    };

    buildInputs = old.buildInputs ++ [ pkgs.jansson ];

    patches = [ ./tramp-detect-wrapped-gvfsd.patch ./clean-env.patch ];
  });
in
{
  my = {
    packages = with pkgs; [
      ## Doom dependencies
      # emacsGit
      # unstable.emacs
      emacsUnstable
      git
      (ripgrep.override { withPCRE2 = true; })

      ## Optional dependencies
      editorconfig-core-c # per-project style config
      fd # faster projectile indexing
      gnutls # for TLS connectivity
      imagemagick # for image-dired
      (lib.mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-tree compression

      ## Module dependencies
      # :checkers spell
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      # :checkers grammar
      languagetool
      # :tools lookup
      sqlite
      # :lang cc
      ccls
      # :lang javascript
      nodePackages.javascript-typescript-langserver
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang rust
      rustfmt
      rls
    ];

    env.PATH = [ "$HOME/.emacs.d/bin" ];
    zsh.rc = lib.readFile <config/emacs/aliases.zsh>;
  };

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
}
