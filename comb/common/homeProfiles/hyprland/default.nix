{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config) styling;

  theme = "Catppuccin-Mocha";

  gtk-theme = "Catppucin-Mocha-Standard-Blue-dark";
  cursor-theme = "Bibata-Modern-Ice";
  cursor-size = 20;
  icon-theme = "Tela-circle-dracula";
  color-scheme = "prefer-dark";
  font-name = "${styling.fonts.sansSerif.name} ${toString styling.fontSizes.desktop}";
  document-font-name = "${styling.fonts.sansSerif.name} ${toString styling.fontSizes.applications}";
  monospace-font-name = "${styling.fonts.monospace.name} ${toString styling.fontSizes.terminal}";
  font-antialiasing = "rgba";
  font-hinting = "full";

  configure-gtk = nixpkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = nixpkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=$2
      setting=$3
      value=$4
      ${nixpkgs.glib}/bin/gsettings set $gnome_schema $setting '$value'
    '';
  };
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

        modules-left = [
          "cpu"
          "memory"
          "temperature"
          "wireplumber"
          "wlr/taskbar"
          "mpris"
        ];

        modules-center = [
          "wlr/workspaces"
        ];

        modules-right = [
          "idle_inhibitor"
          "network"
          "battery"
          "tray"
          "clock"
        ];

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
          status-icons = {
            paused = "⏸";
          };
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
          format-icons = {
            default = ["" ""];
          };
          format-muted = "";
          on-click = "/nix/store/8bipiqr1j2rsnx79jzdazw40fcp7dfhh-pavucontrol-5.0/bin/pavucontrol";
        };

        "wlr/window" = {
          format = "{}";
          max-length = 120;
        };

        "wlr/workspaces" = {
          all-outputs = true;
          disable-scroll = true;
          format = "{name}";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          icon-theme = "Tela-circle-dracula";
          spacing = 0;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [
            "foot"
          ];
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
        # "eDP-1,preferred,0x0,1"
        "DP-4,preferred,0x0,1"
        "DP-3,preferred,3840x0,1"
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
        kb_layout = "us,";
        kb_variant = "dvorak,";
        kb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
      };

      # EXEC-ONCE {{{
      exec-once = [
        "${nixpkgs.swww}/bin/swww init"
      ];
      # }}}

      # EXEC {{{
      exec = [
        "hyprctl setcursor ${cursor-theme} ${toString cursor-size}"
        "${configure-gtk} set org.gnome.desktop.interface cursor-theme '${cursor-theme}'"
        "${configure-gtk} set org.gnome.desktop.interface cursor-size ${toString cursor-size}"

        # "kvantummanager --set ${gtk-theme}"
        "${configure-gtk} set org.gnome.desktop.interface icon-theme '${icon-theme}'"
        "${configure-gtk} set org.gnome.desktop.interface gtk-theme '${gtk-theme}'"
        "${configure-gtk} set org.gnome.desktop.interface color-scheme '${color-scheme}'"

        "${configure-gtk} set org.gnome.desktop.interface font-name '${font-name}"
        "${configure-gtk} set org.gnome.desktop.interface document-font-name '${document-font-name}'"
        "${configure-gtk} set org.gnome.desktop.interface monospace-font-name '${monospace-font-name}'"
        "${configure-gtk} set org.gnome.desktop.interface font-antialiasing '${font-antialiasing}'"
        "${configure-gtk} set org.gnome.desktop.interface font-hinting '${font-hinting}'"
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
        "XCURSOR_THEME,${cursor-theme}"
        "XCURSOR_SIZE,${toString cursor-size}"
      ];
      # }}}

      # GENERAL {{{
      general = {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;

        #"col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        #"col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";

        resize_on_border = true;

        layout = "master";
      };
      # }}}

      # MISC {{{
      misc = {
        vfr = "true";
        vrr = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      # }}}

      # DECORATION {{{
      decoration = {
        rounding = 10;
        # multisample_edges = true;
        drop_shadow = false;

        blur = {
          enabled = true;
          passes = 3;
          size = 6;
          new_optimizations = "on";
          ignore_opacity = "on";
          xray = false;
        };
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
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      # }}}

      master = {
        new_is_master = true;
        no_gaps_when_only = 2;
      };

      # BINDS {{{
      bindm = let
        mod = "SUPER";
      in [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      bind = let
        mod = "SUPER";
        meh = "CONTROL ALT SHIFT";
        hyper = "CONTROL ALT SHIFT SUPER";

        bracketleft = "code:34";
        bracketright = "code:35";
        q = "code:24";
        slash = "code:61";
        h = "code:43";
        k = "code:45";
        j = "code:44";
        l = "code:46";
        f = "code:41";
        grave = "code:49";
        backslash = "code:51";
      in [
        "${mod}, RETURN, exec, foot bash -c \"(tmux ls | grep -qEv 'attached|scratch' && tmux at) || tmux\""
        "${mod} CONTROL, RETURN, exec, foot"
        "${mod}, ${bracketleft}, workspace, e-1"
        "${mod}, ${bracketright}, workspace, e+1"
        "${mod}, ${q}, killactive,"
        "${mod}, SPACE, exec, rofi -show drun"
        "${mod}, TAB, exec, rofi -show window"
        "${mod}, ${slash}, exec, rofi -show filebrowser"

        "${meh}, ${h}, movecurrentworkspacetomonitor, l"
        "${meh}, ${j}, movecurrentworkspacetomonitor, d"
        "${meh}, ${k}, movecurrentworkspacetomonitor, u"
        "${meh}, ${l}, movecurrentworkspacetomonitor, r"

        "${mod} SHIFT, DOWN, movewindow, d"
        "${mod} SHIFT, LEFT, movewindow, l"
        "${mod} SHIFT, RIGHT, movewindow, r"
        "${mod} SHIFT, UP, movewindow, u"

        "${mod} SHIFT, ${h}, movewindow, l"
        "${mod} SHIFT, ${k}, movewindow, u"
        "${mod} SHIFT, ${j}, movewindow, d"
        "${mod} SHIFT, ${l}, movewindow, r"

        "${mod}, ${h}, movefocus, l"
        "${mod}, ${k}, movefocus, u"
        "${mod}, ${j}, movefocus, d"
        "${mod}, ${l}, movefocus, r"

        "${mod} SHIFT, SPACE, togglefloating,"
        "${mod}, ${f}, togglefloating,"
        "${mod} CONTROL, ${f}, fullscreen, 1"

        "${mod}, DOWN, resizeactive, 0 -40"
        "${mod}, LEFT, resizeactive, -40 0"
        "${mod}, RIGHT, resizeactive, -40 0"
        "${mod}, UP, resizeactive, 0 -40"

        "${mod} CONTROL, DOWN, resizeactive, 0 40"
        "${mod} CONTROL, LEFT, resizeactive, 40 0"
        "${mod} CONTROL, RIGHT, resizeactive, 40 0"
        "${mod} CONTROL, UP, resizeactive, 0 40"

        "${mod} SHIFT, ${grave}, exec, emacsclient -n -c -e '(doom/open-scratch-buffer)'"

        "${mod}, ${backslash}, exec, firefox"
      ];
      # }}}
    };
    # }}}

    # EXTRA CONFIG {{{
    extraConfig = ''
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
            bind = SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)}
    '';
    # }}}
  };
  # }}}

  xdg.configFile = {
    "hypr/themes/theme.conf".source = ./_themes + "/${theme}.conf";
  };

  home.packages = [
    nixpkgs.swww
    nixpkgs.glib
    nixpkgs.bibata-cursors
    nixpkgs.tela-circle-icon-theme
  ];
}
