{
  inputs,
  cell,
}: {
  gpg = {
    enable = true;
    homedir = "/home/jboyens/.config/gnupg";
    package = cell.packages.gnupg;
  };
}
