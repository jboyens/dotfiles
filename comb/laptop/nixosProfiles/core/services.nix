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

    settings = {
      devices = {
        mediaserver.id = "L5ZEYSY-NVT73GS-NAD36HV-AO3YJZQ-H53QRJ7-3XVXO5X-PXA2QWN-3J6DQAC";
        kitt.id = "Z6KVBYP-VAKL7WV-GQECKAS-FU23XXB-Q5G2RR3-3JQHCHY-BLGK4UM-B3OETA2";
        pixelfold.id = "DDMWL5O-5YLOW2M-O4LBJI7-MS477DQ-VTKMDLU-WNKAWZB-MPJNYNA-2FEIWAK";
        irongiant.id = "FEEF2M2-B3JYJJX-IHFFP5A-2ZTIGFD-YISKNNB-5G3RML6-ASOG6DB-HSXYKQR";
      };
    };
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

  # ydotool + Pixel Fold + DOIO support
  udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"

    ATTR{idProduct}=="4e11", GOTO="adb", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n", SYMLINK+="android_adb"

    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="d010", MODE="0660", GROUP="input", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Power Management via D-Bus
  upower.enable = true;
}
