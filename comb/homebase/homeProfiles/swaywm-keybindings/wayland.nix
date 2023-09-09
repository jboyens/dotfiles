{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;

  lib = builtins // inputs.nixpkgs.lib // cell.lib;

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

  terminal = "foot";
in {
  windowManager.sway.config = {
    modifier = "Mod4";

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

    keybindings = lib.mkOptionDefault {
      "${super}+Bracketleft" = "workspace prev";
      "${super}+Bracketright" = "workspace next";

      "${super}+${control}+Return" = "exec ${terminal}";
      "${super}+Return" = ''
        exec ${terminal} bash -c "(tmux ls | grep -qEv 'attached|scratch' && tmux at) || tmux"'';

      "${super}+${control}+Slash" = "exec firefox";

      "${super}+q" = "kill";

      # "${super}+space" = "exec $DOTFILES/bin/appmenu";
      "${super}+space" = "exec rofi -show drun";
      "${super}+Tab" = "exec rofi -show window";
      "${super}+Slash" = "exec rofi -show filebrowser";

      # "${super}+p" = "exec $DOTFILES/bin/rofi/bwmenu";
      # "${super}+Shift+p" = "exec $DOTFILES/bin/rofi/bwmenu -r";

      "${super}+Shift+c" = "reload";
      "${super}+${control}+${shift}+Escape" = "reload";

      "${super}+${alt}+Escape" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

      "${super}+Grave" = "exec $DOTFILES/bin/scratch";
      "${super}+${shift}+Grave" = "exec emacsclient -n -c -e '(doom/open-scratch-buffer)'";

      "${super}+e" = "exec emacsclient -e '(emacs-everywhere)'";
      "${super}+t" = "exec emacsclient -n -c ~/Documents/org-mode/todo.org && $DOTFILES/bin/activate emacs";
      "${super}+n" = "exec emacsclient -n -c ~/Documents/org-mode/notes.org && $DOTFILES/bin/activate emacs";
      "${super}+d" = "exec emacsclient -n -c -e '(org-roam-dailies-goto-today)' && $DOTFILES/bin/activate emacs";

      "${super}+${control}+t" = "exec ${config.xdg.configHome}/emacs/bin/org-capture -k t";
      "${super}+${control}+n" = "exec ${config.xdg.configHome}/emacs/bin/org-capture -k n";

      "${super}+m" = "exec emacsclient -c -n -e '(=mu4e)' && $DOTFILES/bin/activate emacs";

      "${hyper}+e" = "exec $DOTFILES/bin/activate emacs";
      "${hyper}+f" = "exec $DOTFILES/bin/activate firefox";
      "${hyper}+s" = "exec $DOTFILES/bin/activate slack";
      "${hyper}+z" = "exec $DOTFILES/bin/activate zoom zoom-us";

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

      "--no-repeat --release ${hyper}+m" = "exec $HOME/sd/mute/slack";

      "${super}+Control+Shift+space" = "exec persway stack-main-rotate-next";
      # "${super}+Shift+Tab" = "exec persway stack-focus-prev";
      # "${super}+Tab" = "exec persway stack-focus-next";
      "${super}+c" = "exec persway change-layout stack-main --size 70 --stack-layout tiled";
      "${super}+Control+space" = "exec persway stack-swap-main";
      # bindsym Mod4+v exec ${inputs.persway.persway} change-layout manual
      # bindsym Mod4+x exec ${inputs.persway.persway} change-layout stack-main --size 70
      # bindsym Mod4+z exec ${inputs.persway.persway} change-layout spiral

      #     floating_modifier $super normal
    };
  };
}
