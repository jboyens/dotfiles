{
  inputs,
  cell,
}: {
  cell.homeProfiles.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';
}
