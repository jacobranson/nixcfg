{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.just;
in {
  options.nixcfg.features.just = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ just ];

    environment.interactiveShellInit = ''
      alias just='just --justfile /etc/justfile --working-directory ~'
    '';

    environment.etc.justfile.text = (builtins.readFile ./justfile);
  };
}
