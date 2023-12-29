{
  inputs,
  cell,
}: let
  inherit (inputs.cells.common) pkgs;
in {
  auto-cpufreq.enable = true;
  thermald.enable = true;

  syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "jboyens";
    configDir = "/home/jboyens/.config/syncthing";
    dataDir = "/home/jboyens/.local/share/syncthing";
  };

  # command scheduler
  # atd.enable = true;

  # GNOME crypto services?
  dbus.packages = [pkgs.gcr];

  # Virtual filesystem support
  gvfs.enable = true;

  # Printing
  printing = {enable = true;};
  system-config-printer.enable = true;

  # D-Bus thumbnailer
  # tumbler.enable = true;

  udev.packages = [
    pkgs.android-udev-rules
    pkgs.solo2-cli
  ];

  # ydotool + Pixel Fold support
  udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"

    ATTR{idProduct}=="4e11", GOTO="adb", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n", SYMLINK+="android_adb"
  '';

  # Power Management via D-Bus
  upower.enable = true;
}
