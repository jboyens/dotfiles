{
  inputs,
  cell,
}: {
  wayland.windowManager.sway.config.window = {
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
    ];
  };
}
