{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.flatpak;
in {
  options.nixcfg.features.flatpak = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    systemd.services.configure-flathub-repo = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      path = with pkgs; [ flatpak ];
      serviceConfig.Type = "oneshot";
      script = ''
        flatpak remote-add --system --if-not-exists flathub \
          https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
