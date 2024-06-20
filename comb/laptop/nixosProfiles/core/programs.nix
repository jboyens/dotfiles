{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs.cells.common) pkgs;
in {
  adb.enable = true;

  hyprland.enable = true;
  hyprlock.enable = true;

  # even though this is managed via home-manager, this sets up some pam stuff
  # that is important
  sway = {
    enable = true;

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
      export WLR_DRM_NO_MODIFIERS=1
    '';
  };

  thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };

  udevil.enable = true;
  dconf.enable = true;

  wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
