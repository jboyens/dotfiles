{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  audio = load ./audio;
  desktop = load ./desktop;
  dev = load ./dev;
  editors = load ./editors;
  email = load ./email;
  keyboard = load ./keyboard;
  shell = load ./shell;
}
