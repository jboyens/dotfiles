{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home = {
    packages = with nixpkgs; [
      python3
      python3Packages.pip
      python3Packages.ipython
      python3Packages.black
      python3Packages.setuptools
      python3Packages.pylint
      poetry
    ];

    shellAliases = {
      py = "python";
      py2 = "python2";
      py3 = "python3";
      po = "poetry";
      ipy = "ipython --no-banner";
      ipylab = "ipython --pylab=qt5 --no-banner";
    };

    sessionVariables = {
      IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
      PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
      PYLINTHOME = "$XDG_DATA_HOME/pylint";
      PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    };
  };
}
