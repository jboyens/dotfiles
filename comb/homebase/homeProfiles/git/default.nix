{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [
    nixpkgs.gitAndTools.git-annex
    nixpkgs.gitAndTools.gh
    nixpkgs.gitAndTools.git-open
    nixpkgs.gitAndTools.diff-so-fancy
    nixpkgs.gitAndTools.git-crypt
    nixpkgs.gitAndTools.git-sync
    nixpkgs.gitAndTools.git-delete-merged-branches
  ];

  programs.zsh.initExtra = ''
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
  '';

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
}
