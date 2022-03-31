{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    sound.enable = true;

    user.packages = with pkgs; [
      easyeffects
    ];

    # systemd.user.services.easyeffects = {
    #   description = "Tuning for headphones";
    #   wantedBy = [ "pipewire.service" ];
    #   after = [ "pipewire.service" ];
    #   bindsTo = [ "pipewire.service" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      media-session.enable = false;
      wireplumber.enable = true;
    };

    user.extraGroups = [ "audio" ];
  };
}
