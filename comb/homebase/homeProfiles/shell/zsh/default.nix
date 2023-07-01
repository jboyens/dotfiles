{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;
in {
  home.packages = with nixpkgs; [ripgrep sudo bottom fzf exa];

  home.sessionPath = [
    "$XDG_CONFIG_HOME/dotfiles/bin"
    "$XDG_CONFIG_HOME/emacs/bin"
  ];

  # these don't work because I'm replacing the whole config
  home.shellAliases = {};

  xdg.enable = true;

  programs.zsh = {
    enable = true;
    # i'll init completion thankyouverymuch
    enableCompletion = false;
    dotDir = ".config/zsh";

    envExtra = builtins.readFile ./_zsh/.zshenv;
    initExtraBeforeCompInit = builtins.readFile ./_zsh/.zshrc;
    initExtra = with builtins;
      lib.concatStringsSep "\n" [
        (readFile ./_zsh/prompt.zsh)
      ];

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$ZDOTDIR/.zhistory";
      save = 100000;
      size = 100000;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file = {
    ".config/zsh/completions/" = {
      source = ./_zsh/completions;
      recursive = true;
    };

    ".config/zsh/keybinds.zsh" = {
      source = ./_zsh/keybinds.zsh;
    };

    ".config/zsh/aliases.zsh" = {
      source = ./_zsh/aliases.zsh;
    };

    ".config/zsh/completion.zsh" = {
      source = ./_zsh/completion.zsh;
    };

    ".config/zsh/config.zsh" = {
      source = ./_zsh/config.zsh;
    };
  };
}
