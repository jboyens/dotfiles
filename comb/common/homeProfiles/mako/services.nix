_: {
  mako = {
    enable = true;
    actions = true;
    anchor = "top-right";
    borderRadius = 2;
    borderSize = 1;
    defaultTimeout = 0;
    height = 1000;
    icons = true;
    ignoreTimeout = false;
    margin = "4,26";
    markup = true;
    maxVisible = -1;
    padding = "20,16";
    width = 440;

    extraConfig = ''
      [app-name="Slack"]
      group-by=summary
      default-timeout=15000
    '';
  };
}
