{
  inputs,
  cell,
}: {
  programs.i3status-rust = {
    enable = true;

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
          icons.icons = "awesome5";
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
          {
            block = "battery";
            format = " $percentage {$time |}";
          }
          {
            block = "net";
            format = " $icon {$signal_strength} ";
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
          {
            block = "time";
            interval = 5;
            format = " $icon $timestamp.datetime(f:'%a, %b %e %l:%M %P') ";
          }
          {
            block = "custom";
            command = "sed 's/  //' <(curl 'https://wttr.in/~47.6038321,-122.3300623?format=1' -s)";
            interval = 600;
          }
        ];
      };
    };
  };
}
