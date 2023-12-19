let
  targetSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID+LlkIE0Ou8mO991M4m1f1gypIZ+u1J6sG89EO7iIt4 root@nixos";
  sourceSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjzIlLawfSp6zmmZZoPtKZoGbsPhxS7BPWsMWRtUblQ code@jacobranson.dev";
  allSystems = [ targetSystem sourceSystem ];
in {
  "systems/anchorage/luks.age".publicKeys = allSystems;
  "systems/anchorage/password.age".publicKeys = allSystems;
  "systems/anchorage/machine-id.age".publicKeys = allSystems;
  "systems/anchorage/ssh_host_ed25519_key.age".publicKeys = allSystems;
}
