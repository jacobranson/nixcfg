{ pkgs, ... }:

{
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";
  home.stateVersion = "23.11";
  programs.git = {
    enable = true;
    userName = "Jacob Ranson";
    userEmail = "code@jacobranson.dev";
    extraConfig.init.defaultBranch = "main";

    lfs.enable = true;
    delta.enable = true;
    gitui.enable = true;
  };

  nixcfg.programs.helix.enable = true;

  programs.gh.enable = true;

  home.packages = with pkgs; [
    devbox
    moar
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    PAGER = "moar";
  };
}
