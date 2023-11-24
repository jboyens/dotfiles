{
  inputs,
  cell,
}: let
  lib = builtins // cell.pkgs.lib // cell.lib;
in {
  xdg.configFile = {
    "zsh/completions/" = {
      source = ./_zsh/completions;
      recursive = true;
    };

    "zsh/keybinds.zsh" = {source = ./_zsh/keybinds.zsh;};
    "zsh/aliases.zsh" = {source = ./_zsh/aliases.zsh;};
    "zsh/completion.zsh" = {source = ./_zsh/completion.zsh;};
    "zsh/config.zsh" = {source = ./_zsh/config.zsh;};
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
}
