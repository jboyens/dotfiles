{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  users.jboyens = {
    initialPassword = "nixos";
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "atd"
      "input"
      "plugdev"
      "audio"
      "libvirtd"
      "vboxusers"
      "docker"
      "adbusers"
    ];
    group = "user";
    shell = nixpkgs.zsh;
  };
}
# root:x:0:
# wheel:x:1:jboyens
# kmem:x:2:
# tty:x:3:
# messagebus:x:4:
# disk:x:6:
# atd:x:12:jboyens
# audio:x:17:jboyens
# floppy:x:18:
# uucp:x:19:
# lp:x:20:
# cdrom:x:24:
# tape:x:25:
# video:x:26:jboyens
# dialout:x:27:
# utmp:x:29:
# adm:x:55:
# systemd-journal:x:62:
# libvirtd:x:67:jboyens
# keys:x:96:
# users:x:100:
# systemd-journal-gateway:x:110:
# docker:x:131:jboyens
# systemd-network:x:152:
# systemd-resolve:x:153:
# systemd-timesync:x:154:
# input:x:174:jboyens
# syncthing:x:237:
# qemu-libvirtd:x:301:
# kvm:x:302:
# render:x:303:
# sgx:x:304:
# shadow:x:318:
# systemd-oom:x:988:
# nscd:x:989:
# rtkit:x:990:
# systemd-coredump:x:991:
# sshd:x:992:
# polkituser:x:993:
# avahi:x:996:
# geoclue:x:999:
# nixbld:x:30000:nixbld1,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld2,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld3,nixbld30,nixbld31,nixbld32,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9
# nogroup:x:65534:

