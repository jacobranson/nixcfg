{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.systemd-boot;
in {
  options.nixcfg.features.systemd-boot = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    boot = {
      # linux kernel version to use
      kernelPackages = pkgs.linuxPackages_latest;

      # set the bootloader to systemd-boot
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      # hides boot logs behind a loading screen
      initrd.systemd.enable = true;
      plymouth.enable = true;

      # TODO supposed to scale the password screen, but doesn't work
      plymouth.extraConfig = "DeviceScale=2";
      
      # hacky way to make the system boot without showing logs.
      # can be overridden by pressing "Escape".
      kernelParams = [ "quiet" ];
      initrd.verbose = false;
      consoleLogLevel = 0;

      # hide the nixos generation boot selection menu by default.
      # can be overridden by holding "Space".
      loader.timeout = 0;
    };
  };
}
