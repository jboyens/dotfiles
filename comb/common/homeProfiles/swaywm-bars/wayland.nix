{
  inputs,
  cell,
  config,
}: {
  windowManager.sway.config.bars = [
    ({
        position = "bottom";
        statusCommand = "i3status-rs config-bottom.toml";
      }
      // config.lib.stylix.sway.bar)
  ];
}
