{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {enable = lib.my.mkBoolOpt false;};

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.git-annex
      unstable.gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
      gitAndTools.git-sync
      gitAndTools.git-delete-merged-branches
      act
    ];

    home.programs.git = {
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

    modules.shell.zsh.rcFiles = ["${configDir}/git/aliases.zsh"];
  };
}
