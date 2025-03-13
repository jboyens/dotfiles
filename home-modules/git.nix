{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.gitAndTools; [
    git-annex
    gh
    git-open
    diff-so-fancy
    git-crypt
    git-sync
    git-delete-merged-branches

    pkgs.git-imerge
  ];

  programs.zsh = {
    shellAliases = {
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
      gll = ''git log --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"a'';
      gL = "gl --stat";
      gp = "git push";
      gpl = "git pull --rebase --autostash";
      gs = "git status --short .";
      gss = "git status";
      gst = "git stash";
      gr = "git reset HEAD";
      gv = "git rev-parse";
    };

    initExtra = ''
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
      ### end git aliases
    '';
  };

  systemd.user.services."git-maintenance@" = {
    Unit = {
      Description = "Optimize Git repositories data";
    };

    Service = {
      Type = "oneshot";
      Environment = [
        "PATH=${pkgs.openssh}/bin:$PATH"
        "SSH_AUTH_SOCK=/run/user/1000/ssh-agent"
      ];
      ExecStart = "${config.programs.git.package}/bin/git for-each-repo --config=maintenance.repo maintenance run --schedule=%i";
      LockPersonality = "yes";
      MemoryDenyWriteExecute = "yes";
      NoNewPrivileges = "yes";
      RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      RestrictNamespaces = "yes";
      RestrictRealtime = "yes";
      RestrictSUIDSGID = "yes";
      SystemCallArchitectures = "native";
      SystemCallFilter = "@system-service";
    };
  };

  systemd.user.timers = let
    git-maintenance = {
      Unit = {
        Description = "Optimize Git repositories data";
      };

      Timer = {
        OnCalendar = "%i";
        Persistent = "true";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  in {
    "git-maintenance@hourly" = git-maintenance;
    "git-maintenance@daily" = git-maintenance;
    "git-maintenance@weekly" = git-maintenance;
  };

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

    # diff-so-fancy.enable = true;
    difftastic = {
      enable = true;
      display = "side-by-side";
    };

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

    signing = {
      key = "785C9CAE60A7B23F";
      signByDefault = true;
    };

    userEmail = "jboyens@moment.dev";
    userName = "JR Boyens";

    extraConfig = {
      core = {
        excludesfile = "~/.gitignore";
        fsmonitor = true;
        untrackedCache = true;
        whitespace = "trailing-space";
      };

      commit.verbose = true;

      credential = {
        "https://github.com".helper = "!gh auth git-credential";
        "https://gist.github.com".helper = "!gh auth git-credential";
        "https://gitlab.com".helper = "!glab auth git-credential";
      };

      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";

      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };

      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
        lisp.xfuncname = "^(((;;;+ )|\\(|([ 	]+\\(((cl-|el-patch-)?def(un|var|macro|method|custom)|gb/))).*)$";
        org.xfuncname = "^(\\*+ +.*)$";
      };

      github.user = "jboyens";

      gitlab = {
        "gitlab.com/api".user = "jr.boyens";
        "gitlab.com/api/v4".user = "jr.boyens";
      };

      help.autocorrect = "prompt";

      maintenance = {
        repo = [
          "/home/jboyens/Workspace/moment"
          "/home/jboyens/Workspace/atlas"
          "/home/jboyens/.config/dotfiles"
        ];
      };

      merge.conflictstyle = "zdiff3";

      protocol.version = 2;

      pull = {
        rebase = true;
        twohead = "ort";
      };

      push = {
        default = "current";
        gpgSign = "if-asked";
        autoSetupRemote = true;
        followTags = true;
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };

      merge = {
        autoStash = true;
      };

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      url = {
        "https://github.com/".insteadOf = "gh:";
        "git@github.com:".insteadOf = "ssh+gh:";
        "git@github.com:jboyens/".insteadOf = "gh:/";
        "https://gist.github.com/".insteadOf = "gist:";
        "https://gitlab.com/".insteadOf = "gl:";
        "git@gitlab.com:".insteadOf = "ssh+gl:";
        "ssh://git@gitlab.com/".insteadOf = "https://gitlab.com/";
      };
    };
  };
}
