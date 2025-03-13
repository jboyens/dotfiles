{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "sway-session.target";
    };
    settings = [
      {
        "position" = "bottom";
        "height" = 37;
        "spacing" = 4;
        "modules-left" = [
          "niri/workspaces"
        ];
        "modules-center" = ["niri/window"];
        "modules-right" = [
          "mpris"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];
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
          "format-icons" = [
            ""
            ""
            ""
          ];
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
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
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
            "default" = [
              ""
              ""
              ""
            ];
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
}
