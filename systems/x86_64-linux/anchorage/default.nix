{ config, inputs, pkgs, system, ... }:

let
  user = "jacob";
  hostname = "anchorage";
  layout = "us";
  locale = "en_US.UTF-8";
  timezone = "America/New_York";
  ssh-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjzIlLawfSp6zmmZZoPtKZoGbsPhxS7BPWsMWRtUblQ code@jacobranson.dev"
  ];
in {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  # linux kernel version to use
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ensure the system can boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ensure the system can connect to the internet
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  
  # assign the machine id
  environment.etc.machine-id.source = "/persist/etc/machine-id";

  # ensure the system can be accessed remotely via ssh
  services.openssh = {
    enable = true;
    
    # ragenix uses this to determine which ssh keys to use for decryption
    hostKeys = [{
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  # configure the keyboard layout
  services.xserver.xkb.layout = layout;
  console.keyMap = layout;

  # set the locale and timezone
  i18n.defaultLocale = locale;
  time.timeZone = timezone;

  # enable the GNOME desktop environment
  nixcfg.desktops.gnome.enable = true;

  # enable autologin
  services.xserver.displayManager.autoLogin.user = user;

  # enable audio via pipewire
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

  # configure standard fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
    ];
  };

  # enable flatpak
  nixcfg.features.flatpak.enable = true;

  # enable firefox web browser
  nixcfg.apps.firefox.enable = true;

  # enable steam for games
  nixcfg.apps.steam.enable = true;

  # enable printer support
  services.printing.enable = true;

  # disable sudo password prompts
  security.sudo.wheelNeedsPassword = false;

  # set environment variables
  environment.variables = {
    NIXCFG_DIR = "/home/jacob/.config/nixcfg";
  };

  # enable just command runner
  nixcfg.features.just.enable = true;

  # enables GPU-passthrough virtualization via KVM, QEMU, Looking Glass
  alaska.features.virtualization = {
    enable = true;
    user = user;
    vfioIds = [ "1002:1681" ];
  };

  # add additional system packages to install
  environment.systemPackages = with pkgs; [];

  # secrets for this machine
  age.secrets = {
    password.file = ../../../secrets/systems/${hostname}/password.age;
  };

  # configure the users of this system
  users.users = {
    root.hashedPasswordFile = config.age.secrets.password.path;
    "${user}" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.password.path;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };

  # configure persistent files via impermanence
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [];
    users."${user}" = {
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Public"
        "Templates"
        "Videos"
        "Steam"
        { directory = ".ssh"; mode = "0700"; }
        ".config/libvirt"
        ".config/nixcfg"
        ".config/gh"
        ".local/share/libvirt"
        ".mozilla"
        ".var"
      ];
      files = [
        ".bash_history"
        ".config/monitors.xml"
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
