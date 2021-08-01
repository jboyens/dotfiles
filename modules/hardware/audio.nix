{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    sound.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      media-session.enable = true;
      media-session.config.bluez-monitor = {
        properties = {
          "bluez5.headset-roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" ];
          "bluez5.msbc-support" = true;
          "bluez5.sbc-xq-support" = true;
        };
      };
      media-session.config.alsa-monitor = {
        "properties" = { };
        "rules" = [
          {
            "actions" = {
              "update-props" = {
                "api.acp.auto-port" = true;
                "api.acp.auto-profile" = true;
                "api.alsa.use-acp" = true;
                "api.alsa.use-ucm" = false;
              };
            };
            "matches" = [{ "device.name" = "~alsa_card.*"; }];
          }
          {
            "actions" = { "update-props" = { "node.pause-on-idle" = false; }; };
            "matches" = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
          }
        ];
      };
    };

    # hardware.pulseaudio.enable = true;
    #
    # # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    # #      for pulseaudio, which I likely don't need. Is there a better way?
    # hardware.pulseaudio.configFile =
    #   let inherit (pkgs) runCommand pulseaudio;
    #       paConfigFile =
    #         runCommand "disablePulseaudioEsoundModule"
    #           { buildInputs = [ pulseaudio ]; } ''
    #             mkdir "$out"
    #             cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
    #             sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
    #           '';
    #   in mkIf config.hardware.pulseaudio.enable
    #     "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" ];
  };
}
