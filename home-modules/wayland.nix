{pkgs, ...}: {
  home.packages = [
    pkgs.dotool
    pkgs.grim
    pkgs.sway-contrib.grimshot
    pkgs.slurp
    (pkgs.enableDebugging pkgs.wayvnc)
    pkgs.wev
    pkgs.wl-clipboard
    pkgs.wl-clipboard-x11
    pkgs.wlr-randr
    pkgs.wob
    pkgs.wofi
    # pkgs.sov
  ];

  # systemd.user.services.dotoold = {
  #   Install = {WantedBy = ["sway-session.target"];};
  #
  #   Service = {
  #     Environment = "PATH=${pkgs.coreutils}/bin:$PATH";
  #     ExecStart = "${pkgs.dotool}/bin/dotoold";
  #     Restart = "on-failure";
  #   };
  #
  #   Unit = {
  #     After = "graphical-session.target";
  #     Description = "dotool reads commands from stdin and simulates keyboard and pointer events";
  #     Documentation = "https://git.sr.ht/~geb/dotool";
  #     PartOf = "graphical-session.target";
  #   };
  # };

  services = {
    wlsunset = {
      enable = false;
      latitude = "47.6062";
      longitude = "-122.3321";
    };
  };
}
