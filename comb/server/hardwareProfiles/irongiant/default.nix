{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
in {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
    common-gpu-intel
    apple-macbook-pro-12-1
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelPackages = nixpkgs.linuxPackages_latest;
    kernelModules = ["kvm-intel"];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
    ];
    extraModprobeConfig = ''
      options nfs nfs4_disable_idmapping=0
    '';
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # CPU
  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "performance";
}
