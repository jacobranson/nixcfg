{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.openssh;
in {
  options.nixcfg.features.openssh = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      
      # ragenix uses this to determine which ssh keys to use for decryption
      hostKeys = [{
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
    };

    nixcfg.features.persistence.userDirectories = [
      { directory = ".ssh"; mode = "0700"; }
    ];
  };
}
