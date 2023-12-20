{ config, lib, pkgs, ... }:

with lib;
with lib.nixcfg;

let
  cfg = config.nixcfg.presets.gnome-desktop;
in {
  options.nixcfg.presets.gnome-desktop = with types; {
    enable   = mkBoolOpt' false;
    user     = mkStrOpt'  "admin";
    hostname = mkStrOpt'  "nixos";
    layout   = mkStrOpt'  "us";
    locale   = mkStrOpt'  "en_US.UTF-8";
    timezone = mkStrOpt'  "America/New_York";
    ssh-keys = mkOpt' (listOf str) [];
    nixcfg-dir = mkStrOpt' "/home/${cfg.user}/.config/nixcfg";
  };

  config = mkIf cfg.enable {
    # pass through all options to the core preset
    nixcfg.presets.core = cfg;

    # enable the GNOME desktop environment
    nixcfg.desktops.gnome = {
      enable = true;
      user = cfg.user;
    };

    # enable autologin
    services.xserver.displayManager.autoLogin.user = cfg.user;

    # enable audio via pipewire
    nixcfg.features.pipewire.enable = true;

    # configure standard fonts
    nixcfg.features.fonts.enable = true;

    # enable flatpak
    nixcfg.features.flatpak.enable = true;

    # enable firefox web browser
    nixcfg.apps.firefox.enable = true;

    # enable steam for games
    nixcfg.apps.steam.enable = true;

    # enable printer support
    services.printing.enable = true;
  };
}
