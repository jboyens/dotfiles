{config, ...}: let
  inherit (config.styling) colors image;

  inside = colors.base01-hex;
  outside = colors.base01-hex;
  ring = colors.base05-hex;
  text = colors.base05-hex;
  positive = colors.base0B-hex;
  negative = colors.base08-hex;
in {
  swaylock = {
    enable = true;
    settings = {
      color = outside;
      scaling = "fill";
      inside-color = inside;
      inside-clear-color = inside;
      inside-caps-lock-color = inside;
      inside-ver-color = inside;
      inside-wrong-color = inside;
      key-hl-color = positive;
      layout-bg-color = inside;
      layout-border-color = ring;
      layout-text-color = text;
      line-uses-inside = true;
      ring-color = ring;
      ring-clear-color = negative;
      ring-caps-lock-color = ring;
      ring-ver-color = positive;
      ring-wrong-color = negative;
      separator-color = "00000000";
      text-color = text;
      text-clear-color = text;
      text-caps-lock-color = text;
      text-ver-color = text;
      text-wrong-color = text;

      image = toString image;
    };
  };
}
