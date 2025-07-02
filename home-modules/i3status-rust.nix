{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}: {
  programs.i3status-rust = {
    enable = true;

    # Bugfix
    # https://nixpk.gs/pr-tracker.html?pr=386738
    package = pkgs.i3status-rust.override {
      inherit (inputs.nixpkgs-unstable.legacyPackages.x86_64-linux) notmuch;
    };

    bars = {
      bottom = {
        settings = {
          theme = {
            theme = "dracula";
            overrides = {
              alternating_tint_bg = "#11111100";
              alternating_tint_fg = "#11111100";
            };
          };

          icons_format = "{icon} ";
          icons.icons = "material-nf";
        };
        theme = "dracula";

        blocks = [
          {
            block = "music";
            format = " $icon $volume_icon $combo $play $next| ";
            seek_step_secs = 10;
            click = [
              {
                button = "up";
                action = "volume_up";
              }
              {
                button = "down";
                action = "volume_down";
              }
              {
                button = "forward";
                action = "seek_forward";
              }
              {
                button = "back";
                action = "seek_backward";
              }
            ];
          }
          {
            block = "cpu";
            merge_with_next = true;
          }
          {
            block = "memory";
            format = " $icon $mem_total_used_percents.eng(w:2) ";
            format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
          }
          (lib.mkIf osConfig.hardware.nvidia.modesetting.enable {
            block = "nvidia_gpu";
          })
          {
            block = "battery";
            format = " $percentage {$time |}";
          }
          {
            block = "net";
            format = " $icon {$signal_strength|^icon_net_up $speed_up / ^icon_net_down $speed_down} ";
          }
          {
            block = "sound";
            click = [
              {
                button = "left";
                cmd = "pavucontrol";
              }
            ];
          }
          (lib.mkIf osConfig.hardware.bluetooth.enable {
            block = "bluetooth";
            mac = "AC:3E:B1:A0:50:99";
            disconnected_format = "";
            format = " $icon $percentage ";
            battery_state = {
              "0..20" = "critical";
              "21..70" = "warning";
              "71..100" = "good";
            };
          })
          {
            block = "time";
            interval = 5;
            format = " $icon $timestamp.datetime(f:'%a, %b %e %l:%M %P') ";
          }
          # {
          #   block = "custom";
          #   command = "sed 's/  //' <(curl 'https://wttr.in/~47.6038321,-122.3300623?format=1' -s)";
          #   interval = 600;
          # }
          {
            block = "weather";
            format = " $icon $weather $temp ";
            interval = 600;
            service = {
              name = "nws";
              coordinates = [
                "47.6039"
                "-122.3301"
              ];
              units = "imperial";
            };
          }
          {
            block = "github";
            format = " $icon $total.eng(w:1) ";
            warning = [
              "mention"
              "ci_activity"
            ];
            critical = [
              "security_alert"
              "review_requested"
            ];
          }
        ];
      };
    };
  };
}
