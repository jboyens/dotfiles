{
  inputs,
  cell,
  ...
}: let
  inherit (cell) pkgs;
in {
  # WAYBAR {{{
  programs.waybar = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.waybar;
    settings = {
      bottom = {
        layer = "top";
        position = "bottom";
        height = 31;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = ["cpu" "memory" "temperature" "wireplumber" "wlr/taskbar" "mpris"];

        modules-center = ["hyprland/workspaces"];

        modules-right = ["idle_inhibitor" "network" "battery" "tray" "clock"];

        battery = {
          format = "  {icon}  {capacity}%";
          format-discharging = "{icon}  {capacity}%";
          format-full = "";
          format-icons = ["" "" "" "" ""];
          interval = 10;
          states = {
            critical = 15;
            warning = 30;
          };
          tooltip = true;
        };

        clock = {
          format = "{: %I:%M %p 󰃭 %a %d}";
          format-alt = "{:󰥔 %H:%M  %b %Y}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
        };

        "clock#date" = {
          format = "  {:%e %b %Y}";
          interval = 10;
          tooltip-format = "{:%e %B %Y}";
        };

        "clock#time" = {
          format = "{:%H:%M:%S}";
          interval = 1;
          tooltip = false;
        };

        cpu = {
          format = "  {usage}% ({load})";
          interval = 5;
          states = {
            critical = 90;
            warning = 70;
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        memory = {
          format = "  {}%";
          interval = 5;
          states = {
            critical = 90;
            warning = 70;
          };
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {paused = "⏸";};
        };

        network = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󱘖 Wired";
          tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          format-linked = "󱘖 {ifname} (No IP)";
          format-disconnected = " Disconnected";
          format-alt = "󰤨 {signalStrength}%";
          interval = 5;
        };

        wireplumber = {
          format = " {icon} {volume}% ";
          format-icons = {default = ["" ""];};
          format-muted = "";
          on-click = "/nix/store/8bipiqr1j2rsnx79jzdazw40fcp7dfhh-pavucontrol-5.0/bin/pavucontrol";
        };

        "wlr/window" = {
          format = "{}";
          max-length = 120;
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };

          disable-scroll = true;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          icon-theme = "Tela-circle-dracula";
          spacing = 0;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = ["foot"];
        };

        temperature = {
          thermal-zone = 3;
          critical-threshold = 80;
          format = "{icon}  {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          interval = 5;
          tooltip = true;
        };

        tray = {
          icon-size = 18;
          spacing = 5;
        };
      };
    };
    style = ''
      @define-color background-darker rgba(30, 31, 41, 230);
      @define-color background #282a36;
      @define-color selection #44475a;
      @define-color foreground #f8f8f2;
      @define-color comment #6272a4;
      @define-color cyan #8be9fd;
      @define-color green #50fa7b;
      @define-color orange #ffb86c;
      @define-color pink #ff79c6;
      @define-color purple #bd93f9;
      @define-color red #ff5555;
      @define-color yellow #f1fa8c;

      * {
          border: none;
          border-radius: 0;
          font-family: FontAwesome, Iosevka;
          font-size: 11pt;
          min-height: 0;
      }

      window#waybar {
          background: @background-darker;
          color: @foreground;
          border-bottom: 2px solid @background;
      }

      #workspaces button {
          padding: 0 10px;
          background: @background;
          color: @foreground;
      }

      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background-image: linear-gradient(0deg, @selection, @background-darker);
      }

      #workspaces button.active {
          background-image: linear-gradient(0deg, @purple, @selection);
      }

      #taskbar button.active {
          background-image: linear-gradient(0deg, @selection, @background-darker);
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #wireplumber,
      #idle_inhibitor,
      #network,
      #battery {
          padding: 0 8px;
          background: @background-darker;
          color: @foreground;
      }
    '';

    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };
  # }}}

  # HYPRLAND {{{
  wayland.windowManager.hyprland = {
    enable = true;

    # SETTINGS {{{
    settings = {
      monitor = [
        "eDP-1,preferred,0x0,1"
        "DP-5,preferred,0x0,1"
        "DP-4,preferred,3840x0,1"
      ];

      # INPUT {{{
      input = {
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
          tap-to-click = true;
        };
      };
      # }}}

      "device:zsa-technology-labs-ergodox-ez-keyboard" = {
        kb_layout = "us";
        kb_variant = "";
      };

      "device:at-translated-set-2-keyboard" = {
        kb_model = "dell";
        kb_layout = "us";
        kb_variant = "dvorak";
        kb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
      };

      exec-once = [''bash -c "swww query || swww init"''];

      # EXEC {{{
      exec = [
        "$DOTFILES/bin/laptop.sh"
      ];
      # }}}

      # ENV {{{
      env = [
        "WLR_DRM_NO_ATOMIC,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCALE_SCREEN_FACTOR,1"
      ];
      # }}}

      # GENERAL {{{
      general = {
        gaps_in = 10;
        gaps_out = 14;
        border_size = 3;

        resize_on_border = false;

        layout = "dwindle";
      };
      # }}}

      # MISC {{{
      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        allow_session_lock_restore = true;
      };
      # }}}

      # DECORATION {{{
      decoration = {
        rounding = 10;
        drop_shadow = true;

        blur = {
          enabled = true;
          passes = 2;
          size = 6;
          new_optimizations = "on";
          ignore_opacity = "on";
          xray = true;
        };

        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;
      };
      # }}}

      # GESTURES {{{
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
      # }}}

      blurls = "waybar";

      # ANIMATIONS {{{
      animations = {
        enabled = "true";

        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          "workspaces, 1, 3.5, easeOutExpo, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };
      # }}}

      master = {
        new_is_master = true;
        no_gaps_when_only = 2;
      };

      dwindle = {
        preserve_split = true;
        smart_split = true;
        no_gaps_when_only = 1;
      };

      # BINDS {{{
      bindm = let
        mod = "SUPER_L";
      in ["${mod}, mouse:272, movewindow" "${mod}, mouse:273, resizewindow"];

      bindl = [
        ",switch:Lid Switch,exec,$DOTFILES/bin/laptop.sh"
      ];

      bind = let
        mod = "SUPER_L";
        meh = "CONTROL ALT SHIFT";
        #hyper = "CONTROL ALT SHIFT SUPER";
      in [
        ''
          ${mod}, Return, exec, foot bash -c "(tmux ls | grep -qEv 'attached|scratch' && tmux at) || tmux"''
        "${mod} CONTROL, Return, exec, foot"
        "${mod}, bracketleft, workspace, e-1"
        "${mod}, bracketright, workspace, e+1"
        "${mod}, q, killactive,"
        "${mod}, space, exec, rofi -show drun"
        "${mod}, Tab, exec, rofi -show window"
        "${mod}, slash, exec, rofi -show filebrowser"
        "${mod} CONTROL, slash, exec, firefox"

        "${meh}, h, movecurrentworkspacetomonitor, l"
        "${meh}, j, movecurrentworkspacetomonitor, d"
        "${meh}, k, movecurrentworkspacetomonitor, u"
        "${meh}, l, movecurrentworkspacetomonitor, r"

        "${mod} SHIFT, Down, movewindow, d"
        "${mod} SHIFT, Left, movewindow, l"
        "${mod} SHIFT, Right, movewindow, r"
        "${mod} SHIFT, Up, movewindow, u"

        "${mod} SHIFT, h, movewindow, l"
        "${mod} SHIFT, j, movewindow, d"
        "${mod} SHIFT, k, movewindow, u"
        "${mod} SHIFT, l, movewindow, r"

        "${mod}, h, movefocus, l"
        "${mod}, k, movefocus, u"
        "${mod}, j, movefocus, d"
        "${mod}, l, movefocus, r"

        "${mod}, f, togglefloating,"
        "${mod} CONTROL, f, fullscreen, 1"

        "${mod}, Down, resizeactive, 0 -40"
        "${mod}, Left, resizeactive, -40 0"
        "${mod}, Right, resizeactive, -40 0"
        "${mod}, Up, resizeactive, 0 -40"

        "${mod} CONTROL, Down, resizeactive, 0 40"
        "${mod} CONTROL, Left, resizeactive, 40 0"
        "${mod} CONTROL, Right, resizeactive, 40 0"
        "${mod} CONTROL, Up, resizeactive, 0 40"

        "${mod} SHIFT, grave, exec, emacsclient -n -c -e '(doom/open-scratch-buffer)'"

        "${mod}, backslash, exec, firefox"

        "CONTROL SHIFT,space,pass,^(Slack)$"

        ",XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl play"
        ",XF86AudioPause,exec,${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioStop,exec,${pkgs.playerctl}/bin/playerctl stop"
        ",XF86AudioPrev,exec,${pkgs.playerctl}/bin/playerctl previous"
        ",XF86AudioNext,exec,${pkgs.playerctl}/bin/playerctl next"

        ",XF86MonBrightnessUp,exec,${pkgs.brightnessctl}/bin/brightness_ctl set +10%"
        ",XF86MonBrightnessDown,exec,${pkgs.brightnessctl}/bin/brightness_ctl set 10%-"

        ",XF86AudioRaiseVolume,exec,pamixer -ui 2"
        ",XF86AudioLowerVolume,exec,pamixer -ud 2"
        ",XF86AudioMute,exec,pamixer -t"
      ];
      # }}}
    };
    # }}}

    # EXTRA CONFIG {{{
    extraConfig = ''
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (x: let
          ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in ''
          bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
          bind = SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        '')
        10)}
    '';
    # }}}
  };
  # }}}

  home.packages = [pkgs.swww];
}
