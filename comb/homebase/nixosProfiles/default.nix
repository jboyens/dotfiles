{
  inputs,
  cell,
}: let
  load = cell.lib.load inputs cell;
in {
  audio = load ./audio;
  cachix = load ./cachix;
  core = load ./core;
  dev = load ./dev;
  gaming = load ./gaming;
  keyboard = load ./keyboard;
  server = load ./server;
  styles = load ./styles;
  vm = load ./vm;
}
