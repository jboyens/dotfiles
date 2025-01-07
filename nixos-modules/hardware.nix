{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    solo2-cli
  ];

  hardware.keyboard.zsa.enable = true;

  services.udev = {
    packages = [
      pkgs.android-udev-rules
      pkgs.solo2-cli
      pkgs.qmk-udev-rules
    ];

    # ydotool + Pixel Fold + DOIO support
    extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"

      ATTR{idProduct}=="4e11", GOTO="adb", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n", SYMLINK+="android_adb"

      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="d010", MODE="0660", GROUP="input", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
