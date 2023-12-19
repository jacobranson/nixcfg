{ config, lib, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.apps.steam;
in {
  options.nixcfg.apps.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    system.userActivationScripts.makeSteamSymlinks.text = ''
      ln -sfn ~/Steam/.local/share/Steam/ ~/.local/share/Steam
      ln -sfn ~/Steam/.steam ~/.steam
    '';
  };
}
