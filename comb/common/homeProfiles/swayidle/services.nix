{
  inputs,
  cell,
}: let
  inherit (cell) pkgs;
  inherit (pkgs) sway swaylock;
in {
  swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 600;
        command = "${swaylock}/bin/swaylock -f";
      }
      {
        timeout = 1200;
        command = "${sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${sway}/bin/swaymsg 'output * power on'";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${swaylock}/bin/swaylock -f";
      }
    ];
  };
}
