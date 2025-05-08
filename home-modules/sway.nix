{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.wayland.windowManager.sway;
in {
  home.packages = lib.mkIf cfg.enable [
    # autotiling
    # fuzzel
    # pkgs.i3status-rust
    # qt5.qtwayland
    # broken as of 2023-08-11
    # sirula
    pkgs.swaybg
    pkgs.swayidle
    pkgs.swaylock
    # swayr
  ];

  programs = {
    swaylock.enable = true;

    swayr = {
      enable = true;
      settings = {
        menu = {
          executable = "${pkgs.wofi}/bin/wofi";
          args = [
            "--show=dmenu"
            "--allow-markup"
            "--allow-images"
            "--insensitive"
            "--cache-file=/dev/null"
            "--parse-search"
            "--height=40%"
            "--prompt={prompt}"
          ];
        };
        format = {
          output_format = "{indent}Output {name}    ({id})";
          workspace_format = "{indent}Workspace {name} [{layout}] on output {output_name}    ({id})";
          container_format = "{indent}Container [{layout}] {marks} on workspace {workspace_name}    ({id})";
          window_format = "img:{app_icon}:text:{indent}{app_name} — {urgency_start}“{title}”{urgency_end} {marks} on workspace {workspace_name} / {output_name}    ({id})";
          indent = "    ";
          urgency_start = "";
          urgency_end = "";
          html_escape = true;
        };
        layout = {
          auto_tile = false;
          auto_tile_min_window_width_per_output_width = [
            [
              800
              400
            ]
            [
              1024
              500
            ]
            [
              1280
              600
            ]
            [
              1400
              680
            ]
            [
              1440
              700
            ]
            [
              1600
              780
            ]
            [
              1680
              780
            ]
            [
              1920
              920
            ]
            [
              2048
              980
            ]
            [
              2560
              1000
            ]
            [
              3440
              1200
            ]
            [
              3840
              1280
            ]
            [
              4096
              1400
            ]
            [
              4480
              1600
            ]
            [
              7680
              2400
            ]
          ];
        };
        focus = {
          lockin_delay = 750;
        };
        misc = {
          seq_inhibit = false;
        };
      };
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
    };
  };

  services = {
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

  wayland.windowManager.sway = {
    enable = true;
    package = null; # must be managed at the NixOS level
    systemd.enable = true;
    swaynag.enable = true;

    extraConfig = ''
      bindswitch --locked lid:toggle exec $DOTFILES/bin/laptop.sh
    '';

    config = {
      # terminal = "foot";
      terminal = "ghostty";

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

      assigns = {
        "1" = [
          {app_id = "Slack";}
          {app_id = "signal";}
          {app_id = "discord";}
        ];
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = [
            "eDP-1"
            "DP-2"
          ];
        }
        {
          workspace = "2";
          output = [
            "DP-6"
            "DP-1"
          ];
        }
      ];

      startup = [
        {
          command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob";
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
        {
          command = "signal-desktop";
          always = false;
        }
        {
          command = "discord";
          always = false;
        }
        {
          command = "slack";
          always = false;
        }
        # {
        #   command = "eww open bar";
        #   always = false;
        # }
      ];

      window = {
        commands = [
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {
              app_id = "scratch";
            };
          }
          {
            command = "floating true,,resize set width 1200 height 560,,border pixel 2";
            criteria = {
              class = "scratch";
            };
          }
          {
            command = "floating true,,resize set width 940 height 760,,border pixel 2";
            criteria = {
              title = "doom-capture";
            };
          }
          {
            command = "floating true,,resize set width 1200 height 800,,border pixel 2,,move position center";
            criteria = {
              app_id = "pavucontrol";
            };
          }
          {
            command = "floating true,,move position 50ppt 100ppt";
            criteria = {
              title = "Firefox - Sharing Indicator";
            };
          }
          {
            command = "floating true";
            criteria = {
              class = "floating";
            };
          }
          {
            command = "floating true,,sticky true";
            criteria = {
              class = "zoom";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "dialog";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "utility";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "toolbar";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "splash";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "menu";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "dropdown_menu";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "popup_menu";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "tooltip";
            };
          }
          {
            command = "floating enable";
            criteria = {
              window_type = "notification";
            };
          }
          {
            command = "shortcuts_inhibitor disable";
            criteria = {
              app_id = "^chrome-.*";
            };
          }
          {
            command = "floating enable,,move to position center,,resize set 800 600,,border pixel 3";
            criteria = {
              title = "^Emacs Everywhere.*";
            };
          }
          {
            command = "resize set width 384px,,focus";
            criteria = {
              title = "^Extension: \\(Bitwarden.*";
            };
          }
          {
            command = "move to output eDP-1,,floating yes";
            criteria = {
              app_id = "moment-tauri-app";
            };
          }
        ];
      };

      # bars = [];
      bars = [
        (
          {
            position = "bottom";
            statusCommand = "i3status-rs config-bottom.toml";
          }
          // config.lib.stylix.sway.bar
        )
      ];
    };
  };
}
