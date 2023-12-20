{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.features.persistence;
in {
  options.nixcfg.features.persistence = with types; {
    enable  = mkBoolOpt' false;
    users   = mkOpt' (listOf str) [];
    persist = mkStrOpt' "/persist";

    directories = mkOpt' (listOf anything) [];
    files = mkOpt' (listOf anything) [];
    userDirectories = mkOpt' (listOf anything) [];
    userFiles = mkOpt' (listOf anything) [];
  };

  config = mkIf cfg.enable {
    environment.persistence."${cfg.persist}" = {
      hideMounts = true;
      directories = cfg.directories;
      files = cfg.files;
      users = (
        builtins.listToAttrs (
          builtins.map(
            u: {
              name = u;
              value = {
                directories = cfg.userDirectories;
                files = cfg.userFiles;
              };
            }
          )
          cfg.users
        )
      );
    };
  };
}
