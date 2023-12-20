{ pkgs, ... }:

{
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  programs.git = {
    enable = true;
    userName = "Jacob Ranson";
    userEmail = "code@jacobranson.dev";
    extraConfig.init.defaultBranch = "main";

    lfs.enable = true;
    delta.enable = true;
  };

  programs.gitui.enable = true;

  programs.gh.enable = true;

  nixcfg.programs.helix.enable = true;

  home.packages = with pkgs; [
    devbox
    moar
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    PAGER = "moar";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
