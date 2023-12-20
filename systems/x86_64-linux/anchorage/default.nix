{ config, inputs, pkgs, system, ... }:

let
  user = "jacob";
in {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  nixcfg.presets.gnome-desktop = {
    enable = true;
    inherit user;
    hostname = "anchorage";
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjzIlLawfSp6zmmZZoPtKZoGbsPhxS7BPWsMWRtUblQ code@jacobranson.dev"
    ];
  };

  # enables GPU-passthrough virtualisation via KVM, QEMU, Looking Glass
  nixcfg.features.virtualisation = {
    enable = true;
    inherit user;
    vfioIds = [ "1002:1681" ];
  };

  # add additional system packages to install
  environment.systemPackages = with pkgs; [];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
