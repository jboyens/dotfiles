{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  # Use a stable profile name so we can target it in themes
  xdg.configFile = {
    "tmux/swap-pane.sh".source = ./_tmux/swap-pane.sh;
    # "tmux/theme.conf".source = ./_tmux/theme.conf;
  };

  home.sessionVariables = {
    TMUX_HOME = "${config.xdg.configHome}/tmux";
  };

  programs.zsh.initExtra = ''
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
  '';

  programs.tmux = {
    enable = true;

    aggressiveResize = false;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-c";
    terminal = "foot";

    extraConfig = ''
      setw -g automatic-rename on      # rename window after current program
      set  -g renumber-windows on      # renumber windows when one is closed

      # Address vim-mode switching delay (http://superuser.com/a/252717/65504)
      set -sg repeat-time   600

      ########################################
      # Keybinds                             #
      ########################################

      bind c new-window      -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind H run '$TMUX_HOME/swap-pane.sh left'
      bind J run '$TMUX_HOME/swap-pane.sh down'
      bind K run '$TMUX_HOME/swap-pane.sh up'
      bind L run '$TMUX_HOME/swap-pane.sh right'
      bind M run '$TMUX_HOME/swap-pane.sh master'

      bind o resize-pane -Z
      bind S choose-session
      bind W choose-window
      bind / choose-session
      bind . choose-window

      # bind = select-layout tiled
      bind | select-layout even-horizontal
      bind _ select-layout even-vertical

      # Disable confirmation
      bind x kill-pane
      bind X kill-window
      bind q kill-session
      bind Q kill-server

      # Smart pane switching with awareness of vim splits
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"'
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
      bind -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind C-w last-pane
      bind C-n next-window
      bind C-p previous-window

      # break pane into a window
      bind = select-layout even-vertical
      bind + select-layout even-horizontal
      bind - break-pane
      bind _ join-pane

      bind ^r refresh-client

      ########################################
      # Copy mode                            #
      ########################################

      bind Enter copy-mode # enter copy mode
      bind b list-buffers  # list paster buffers
      bind B choose-buffer # choose which buffer to paste from
      bind p paste-buffer  # paste from the top paste buffer
      bind P run "xclip -selection clipboard -o | tmux load-buffer - ; tmux paste-buffer"

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi Escape send-keys -X cancel
      bind -T copy-mode-vi C-g send-keys -X cancel
      bind -T copy-mode-vi H send-keys -X start-of-line
      bind -T copy-mode-vi L send-keys -X end-of-line
    '';
    plugins = with nixpkgs; [
      {
        plugin = tmuxPlugins.catppuccin.overrideAttrs (oa: {
          version = "unstable-2023-08-28";
          src = fetchFromGitHub {
            owner = "catppuccin";
            repo = "tmux";
            rev = "7a284c98e5df4cc84a1a45ad633916f0b2b916b2";
            sha256 = "sha256-jxcxW0gEfXaSt8VM3UIs0dKNKaHb8JSEQBBV3SVjW/A=";
          };
        });
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'

          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules "application session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
      {plugin = tmuxPlugins.copycat;}
      {plugin = tmuxPlugins.prefix-highlight;}
      {plugin = tmuxPlugins.yank;}
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-processes 'ssh sqlite3 "git log"'
        '';
      }
      {
        plugin = tmuxPlugins.open;
        extraConfig = ''
          set -g @open-editor 'C-e'
          set -g @open-S 'https://www.duckduckgo.com/'
        '';
      }
    ];
  };
}
