{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.pipewire;
in {
  options.nixcfg.features.pipewire = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    sound.enable = false;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
