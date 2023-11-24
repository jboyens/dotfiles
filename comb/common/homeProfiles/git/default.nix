{
  inputs,
  cell,
}: let
  inherit (cell) pkgs;
in {
  home.packages = [
    pkgs.gitAndTools.git-annex
    pkgs.gitAndTools.gh
    pkgs.gitAndTools.git-open
    pkgs.gitAndTools.diff-so-fancy
    pkgs.gitAndTools.git-crypt
    pkgs.gitAndTools.git-sync
    pkgs.gitAndTools.git-delete-merged-branches
    pkgs.git-imerge
  ];

  programs.zsh.initExtra = ''
    ### git aliases
    alias cdg='cd `git rev-parse --show-toplevel`'
    alias git="noglob git"
    alias ga="git add"
    alias gap="git add --patch"
    alias gb="git branch -av"
    alias gop="git open"
    alias gbl="git blame"
    alias gc="git commit"
    alias gcm="git commit -m"
    alias gca="git commit --amend"
    alias gcf="git commit --fixup"
    alias gcl="git clone"
    alias gco="git checkout"
    alias gcoo="git checkout --"
    alias gf="git fetch"
    alias gi="git init"
    alias gl='git log --graph --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
    alias gll='git log --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
    alias gL="gl --stat"
    alias gp="git push"
    alias gpl="git pull --rebase --autostash"
    alias gs="git status --short ."
    alias gss="git status"
    alias gst="git stash"
    alias gr="git reset HEAD"
    alias gv="git rev-parse"

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
  '';

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      unadd = "reset HEAD";
      ranked-authors = "!git authors | sort | uniq -c | sort -n";
      emails = ''!git log --format="%aE" | sort -u'';
      email-domains = ''!git log --format="%aE" | awk -F'@' '{print $2}' | sort -u'';
      st = "status";

      up = "push";
      down = "pull";
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
      credential."https://gitlab.com".helper = "!glab auth git-credential";

      diff = {
        algorithm = "histogram";
        lisp.xfuncname = "^(((;;;+ )|\\(|([ 	]+\\(((cl-|el-patch-)?def(un|var|macro|method|custom)|gb/))).*)$";
        org.xfuncname = "^(\\*+ +.*)$";
      };

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
}
