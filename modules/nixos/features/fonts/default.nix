{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.fonts;
in {
  options.nixcfg.features.fonts = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk
      ];
    };
  };
}
