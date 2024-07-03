{
  pkgs,
  lib,
  ...
}: let
  wobmute = pkgs.writeShellScriptBin "wobmute" ''
    pamixer -t

    if [ $(pamixer --get-mute) = 'true' ]
    then
      echo 0
    else
      pamixer --get-volume
    fi > $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob
  '';
in {
  home.packages = [
    pkgs.hyprland
    pkgs.glib.bin
  ];

  services.hypridle = {
    enable = true;
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";

      general = {
        lock_cmd = "$lock_cmd";
        before_sleep_cmd = "$lock_cmd";
      };

      listener = [
        {
          timeout = 180; # 3mins
          on-timeout = "$lock_cmd";
        }
        {
          timeout = 240; # 4mins
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      # $text_color = rgba(E3E1EFFF)
      # $entry_background_color = rgba(12131C11)
      # $entry_border_color = rgba(908F9F55)
      # $entry_color = rgba(C6C5D6FF)
      "$text_color" = "rgba(FFFFFFFF)";
      "$entry_background_color" = "rgba(33333311)";
      "$entry_border_color" = "rgba(3B3B3B55)";
      "$entry_color" = "rgba(FFFFFFFF)";
      "$font_family" = "Iosevka Aile";
      "$font_family_clock" = "Iosevka Aile";
      "$font_material_symbols" = "Material Symbols Rounded";

      background = {
        # color = rgba(0D0D17FF)
        color = "rgba(000000FF)";
        # path = {{ SWWW_WALL }}
        # path = screenshot
        # blur_size = 5
        # blur_passes = 4
      };

      input-field = {
        monitor = "";
        size = "250, 50";
        outline_thickness = 2;
        dots_size = 0.1;
        dots_spacing = 0.3;
        outer_color = "$entry_border_color";
        inner_color = "$entry_background_color";
        font_color = "$entry_color";
        # fade_on_empty = true

        position = "0, 20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          # Clock
          monitor = "";
          text = "$TIME";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "$text_color";
          font_size = 65;
          font_family = "$font_family_clock";

          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          # Greeting
          monitor = "";
          text = "hi $USER !!!";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "$text_color";
          font_size = 20;
          font_family = "$font_family";

          position = "0, 240";
          halign = "center";
          valign = "center";
        }
        {
          # lock icon
          monitor = "";
          text = "lock";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "$text_color";
          font_size = 21;
          font_family = "$font_material_symbols";

          position = "0, 65";
          halign = "center";
          valign = "bottom";
        }
        {
          # "locked" text
          monitor = "";
          text = "locked";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "$text_color";
          font_size = 14;
          font_family = "$font_family";

          position = "0, 45";
          halign = "center";
          valign = "bottom";
        }
        {
          # Status
          monitor = "";
          text = "cmd[update:5000] ~/.config/hypr/hyprlock/status.sh";
          shadow_passes = 1;
          shadow_boost = 0.5;
          color = "$text_color";
          font_size = 14;
          font_family = "$font_family";

          position = "30, -30";
          halign = "left";
          valign = "top";
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        "position" = "bottom";
        "height" = 37;
        "spacing" = 4;
        "modules-left" = ["hyprland/workspaces"];
        "modules-center" = ["hyprland/window"];
        "modules-right" = ["mpris" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "clock" "tray"];
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          "spacing" = 10;
        };
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "{}% ";
        };
        "temperature" = {
          "hwmon-path" = "/sys/class/hwmon/hwmon5/temp1_input";
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = ["" "" ""];
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" ""];
        };
        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}= {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };
        "mpris" = {
          "format" = "{player_icon} {dynamic}";
          "format-paused" = "{status_icon} <i>{dynamic}</i>";
          "player-icons" = {
            "default" = "▶";
            "mpv" = "🎵";
          };
          "status-icons" = {
            "paused" = "⏸";
          };
          "ignored-players" = ["firefox"];
        };
      }
    ];
    style = ''
      widget label {
        border-radius: 8px;
        margin: 0 8px 0 0;
        padding: 2px;
      }

      #keyboard-state {
        border-radius: 8px;
        margin: 0 8px 0 0;
        padding: 2px;
      }

      #keyboard-state > label {
        margin: 0 4px 0 0;
        color: #fff;
      }

      #language {
        color: #fff;
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
      variables = ["--all"];
    };

    settings = {
      monitor = [
        "DP-1,3440x1440@160Hz,3840x370,1"
        "DP-2,3840x2160@60Hz,0x0,1"
      ];

      # Set programs that you use
      "$terminal" = "foot";
      "$fileManager" = "thunar";
      "$menu" = "fuzzel --show-actions";

      exec-once = [
        "mkfifo $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob && tail -f $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob | ${pkgs.wob}/bin/wob"
        "${pkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "eww open bar --screen 0"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "SDL_VIDEODRIVER,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "MOZ_WEBRENDER,1"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DBUS_REMOTE,1"
      ];

      general = {
        gaps_in = 8;
        gaps_out = 8;

        border_size = 0;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = "-1"; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = "-1"; # If true disables the random hyprland logo / anime girl background. :(
        key_press_enables_dpms = true;
      };

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        resolve_binds_by_sym = 1;

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = false;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = false;
      };

      device = {
        name = "at-translated-set-2-keyboard";
        kb_layout = "us";
        kb_variant = "dvorak";
        kb_model = "dell";
        kb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
        kb_rules = "";
      };

      bind = [
        "SUPER_CTRL, RETURN, exec, $terminal"
        ''SUPER,RETURN,exec,foot ${pkgs.bash}/bin/bash -c "(tmux ls | grep -qEv 'attached|scratch' && tmux at) || tmux"''
        "SUPER, Q, killactive,"

        "SUPER_CTRL_ALT_SHIFT,E,exec,$DOTFILES/bin/activate emacs"
        "SUPER_CTRL_ALT_SHIFT,F,exec,$DOTFILES/bin/activate firefox"
        "SUPER_CTRL_ALT_SHIFT,S,exec,$DOTFILES/bin/activate slack"
        "SUPER_CTRL_ALT_SHIFT,Z,exec,$DOTFILES/bin/activate zoom zoom-us"

        "SUPER,SLASH,exec,rofi -show filebrowser"
        "SUPER,TAB,exec,rofi -show window"

        # bind = SUPER, M, exit,
        # bind = SUPER, E, exec, $fileManager
        "SUPER, F, togglefloating,"
        "SUPER SHIFT, SPACE, togglefloating,"
        "SUPER CTRL, F, fullscreen, 1"
        "SUPER, SPACE, exec, $menu"
        "SUPER, P, pseudo,"
        # bind = SUPER, J, togglesplit, # dwindle

        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        "SUPER CTRL, H, focusmonitor, l"
        "SUPER CTRL, L, focusmonitor, r"
        "SUPER CTRL, K, focusmonitor, u"
        "SUPER CTRL, J, focusmonitor, d"
        "SUPER CTRL,SLASH,exec,firefox"

        # Switch workspaces with mainMod + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        "SUPER SHIFT,H,movewindoworgroup,l"
        "SUPER SHIFT,J,movewindoworgroup,d"
        "SUPER SHIFT,K,movewindoworgroup,u"
        "SUPER SHIFT,L,movewindoworgroup,r"

        "SUPER CTRL SHIFT, h, moveworkspacetomonitor, left"
        "SUPER CTRL SHIFT, j, moveworkspacetomonitor, down"
        "SUPER CTRL SHIFT, k, moveworkspacetomonitor, up"
        "SUPER CTRL SHIFT, l, moveworkspacetomonitor, right"

        "SUPER,BRACKETLEFT,workspace,e-1"
        "SUPER,BRACKETRIGHT,workspace,e+1"

        "SUPER CTRL,DOWN,resizeactive,0 -40"
        "SUPER CTRL,UP,resizeactive,0 -40"
        "SUPER CTRL,LEFT,resizeactive,-40 0"
        "SUPER CTRL,RIGHT,resizeactive,-40 0"

        "SUPER,DOWN,resizeactive,0 40"
        "SUPER,UP,resizeactive,0 40"
        "SUPER,LEFT,resizeactive,40 0"
        "SUPER,RIGHT,resizeactive,40 0"

        "SUPER CTRL,N,exec,/home/jboyens/.config/emacs/bin/org-capture -k n"
        "SUPER CTRL,T,exec,/home/jboyens/.config/emacs/bin/org-capture -k t"
        "SUPER,d,exec,emacsclient -n -c -e '(org-roam-dailies-goto-today)' && hyprctl dispatch focuswindow emacs"
        "SUPER,e,exec,emacsclient -e '(emacs-everywhere)' && hyprctl dispatch focuswindow emacs"
        "SUPER,n,exec,emacsclient -n -c ~/Documents/org-mode/notes.org && hyprctl dispatch focuswindow emacs"
        "SUPER,t,exec,emacsclient -n -c ~/Documents/org-mode/todo.org && hyprctl dispatch focuswindow emacs"
        "SUPER,m,exec,emacsclient -n -c -e '(=mu4e)' && hyprctl dispatch focuswindow emacs"

        "SUPER,GRAVE,exec,$DOTFILES/bin/scratch"
        "SUPER SHIFT,GRAVE,exec,emacsclient -n -c -e '(doom/open-scratch-buffer)'"

        # Example special workspace (scratchpad)
        "SUPER, MINUS, togglespecialworkspace, magic"
        "SUPER SHIFT, MINUS, movetoworkspace, special:magic"
        "CTRL SHIFT, SPACE, pass, ^(Slack)$"
        "CTRL SHIFT, M, pass, ^(Discord)$"

        ",XF86AudioLowerVolume,exec,pamixer -ud 2 && pamixer --get-volume > $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob"
        ",XF86AudioMute,exec,${lib.getExe wobmute}"
        ",XF86AudioNext,exec,${lib.getExe pkgs.playerctl} next"
        ",XF86AudioPause,exec,${lib.getExe pkgs.playerctl} pause"
        ",XF86AudioPlay,exec,${lib.getExe pkgs.playerctl} play"
        ",code:164,exec,${lib.getExe pkgs.playerctl} play-pause"
        ",XF86AudioPrev,exec,${lib.getExe pkgs.playerctl} previous"
        ",XF86AudioRaiseVolume,exec,pamixer -ui 2 && pamixer --get-volume > $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob"
        ",XF86AudioStop,exec,${lib.getExe pkgs.playerctl} stop"
        ",XF86MonBrightnessDown,exec,${lib.getExe pkgs.brightnessctl} set 10%- && $DOTFILES/bin/brightnessctl_perc > $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob"
        ",XF86MonBrightnessUp,exec,${lib.getExe pkgs.brightnessctl} set +10% && $DOTFILES/bin/brightnessctl_perc > $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/fifo.wob"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
        "float, class:(scratch)"
        "bordersize 1, class:(scratch)"
      ];
    };
  };
}
