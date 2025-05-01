{lib, ...}: {
  programs.zsh.initContent = lib.mkOrder 550 ''
    function osc7-pwd() {
        emulate -L zsh # also sets localoptions for us
        setopt extendedglob
        local LC_ALL=C
        printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
    }

    function chpwd-osc7-pwd() {
        (( ZSH_SUBSHELL )) || osc7-pwd
    }
    add-zsh-hook -Uz chpwd chpwd-osc7-pwd

    function precmd() {
        if ! builtin zle; then
            print -n "\e]133;D\e\\"
        fi
        print -Pn "\e]133;A\e\\"
    }

    function preexec() {
        print -n "\e]133;C\e\\"
    }
  '';

  # home.file.foot-server-override = {
  #   enable = true;
  #   text = ''
  #     [Service]
  #     Environment=PATH=${pkgs.foot}/bin:$PATH
  #   '';
  #   target = ".config/systemd/user/foot-server.service.d/override.conf";
  # };

  programs.foot = {
    enable = true;
    # don't use this; use my service
    # server.enable = true;

    settings = {
      main = {
        pad = "10x10";
        # override stylix crap
        dpi-aware = lib.mkForce "yes";
        font = lib.mkForce "Iosevka:size=10, Noto Color Emoji:size=10";
      };

      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        show-urls-launch = "Control+Shift+u";
        pipe-command-output = ''
          [sh -c "f=$(mktemp); cat - > $f; foot emacsclient $f; rm $f"] Control+Shift+g
        '';
        unicode-input = "none";
      };
    };
  };
}
