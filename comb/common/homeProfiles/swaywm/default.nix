{
  cell,
  config,
  ...
}: let
  inherit (cell) pkgs;
in {
  home.packages = [pkgs.dotool];

  systemd.user.services.dotoold = {
    Install = {WantedBy = ["sway-session.target"];};

    Service = {
      Environment = "PATH=${pkgs.coreutils}/bin:$PATH";
      ExecStart = "${pkgs.dotool}/bin/dotoold";
      Restart = "on-failure";
    };

    Unit = {
      After = "graphical-session.target";
      Description = "dotool reads commands from stdin and simulates keyboard and pointer events";
      Documentation = "https://git.sr.ht/~geb/dotool";
      PartOf = "graphical-session.target";
    };
  };

  programs.swaylock.enable = true;

  services = {
    wlsunset = {
      enable = true;
      latitude = "47.6062";
      longitude = "-122.3321";
    };

    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 1200;
          command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
        }
      ];

      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = [
      {
        "position" = "bottom";
        "height" = 37;
        "spacing" = 4;
        "modules-left" = ["sway/workspaces" "sway/mode" "sway/scratchpad"];
        "modules-center" = ["sway/window"];
        "modules-right" = ["mpris" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray"];
        "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
          "format" = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = ["" ""];
          "tooltip" = true;
          "tooltip-format" = "{app}: {title}";
        };
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

  wayland.windowManager.sway = {
    enable = true;
    package = null; # must be managed at the NixOS level
    systemd.enable = true;
    swaynag.enable = true;

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_WEBRENDER=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
      export NIXOS_OZONE_WL=1
      export XCURSOR_PATH=${pkgs.dracula-icon-theme}/share/icons
      export XCURSOR_THEME=Dracula
      export WLR_DRM_NO_MODIFIERS=1
    '';

    extraConfig = ''
      bindswitch --locked lid:toggle exec $DOTFILES/bin/laptop.sh
    '';

    config = {
      terminal = "foot";

      window.titlebar = false;
      floating.titlebar = false;

      focus = {
        followMouse = true;
        mouseWarping = "container";
        newWindow = "smart";
      };

      gaps = {
        inner = 8;
        smartGaps = true;
      };

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_model = "dell";
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Touchpad" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "10182:3936:VEN_27C6:00_27C6:0F60_Touchpad" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "10182:3936:VEN_27C6:00_27C6:0F60_Mouse" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Mouse" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      workspaceOutputAssign = [];

      startup = [
        {
          command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob";
          always = false;
        }
        # {
        #   command = "persway daemon -w -d spiral";
        #   always = false;
        # }
        {
          command = "${pkgs.swayr}/bin/swayrd";
          always = false;
        }
        {
          command = "${pkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G";
          always = false;
        }
        {
          command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          always = false;
        }
      ];

      window = {
        commands = [
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {app_id = "scratch";};
          }
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {class = "scratch";};
          }
          {
            command = "floating true,,resize set width 940 height 760,,border pixel 2";
            criteria = {title = "doom-capture";};
          }
          {
            command = "floating true,,resize set width 1200 height 800,,border pixel 2,,move position center";
            criteria = {app_id = "pavucontrol";};
          }
          {
            command = "floating true,,move position 50ppt 100ppt";
            criteria = {title = "Firefox - Sharing Indicator";};
          }
          {
            command = "floating true";
            criteria = {class = "floating";};
          }
          {
            command = "floating true,,sticky true";
            criteria = {title = "Zoom Meeting";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "dialog";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "utility";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "toolbar";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "splash";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "dropdown_menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "popup_menu";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "tooltip";};
          }
          {
            command = "floating enable";
            criteria = {window_type = "notification";};
          }
          {
            command = "shortcuts_inhibitor disable";
            criteria = {app_id = "^chrome-.*";};
          }
          {
            command = "floating enable,,move to position center,,resize set 800 600,,border pixel 3";
            criteria = {title = "^Emacs Everywhere.*";};
          }
          {
            command = "resize set width 384px,,focus";
            criteria = {title = "^Extension: \\(Bitwarden.*";};
          }
        ];
      };

      bars = [];
      # bars = [
      #   ({
      #       position = "bottom";
      #       statusCommand = "i3status-rs config-bottom.toml";
      #     }
      #     // config.lib.stylix.sway.bar)
      # ];
    };
  };
}
