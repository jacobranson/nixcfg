{ pkgs, inputs, system, ... }:

pkgs.mkShell {
  shellHook = ''
    export EDITOR=hx

    agenix() {
      command agenix --rules secrets/__secrets__.nix "$@"
    }

    decrypt() {
      agenix --editor cat --edit "$1" | grep -v "wasn't changed"
    }

    sysdecrypt() {
      decrypt "secrets/systems/$hostname/$1.age"
    }

    getmachineid() {
      cat mnt/etc/machine-id \
        || sysdecrypt machine-id || echo not found
    }

    getkey() {
      cat mnt/etc/ssh/ssh_host_ed25519_key || \
        sysdecrypt ssh_host_ed25519_key || echo not found
    }

    getpubkey() {
      cat mnt/etc/ssh/ssh_host_ed25519_key.pub | tr -d '\n' || \
        sysdecrypt ssh_host_ed25519_key.pub || echo not found
    }

    getsrcpubkey() {
      cat ~/.ssh/id_ed25519.pub | tr -d '\n' || echo not found
    }

    getdisks() {
      cat mnt/etc/disks.txt || echo not found
    }

    mkupasswd() {
      openssl passwd -6 -stdin | tr -d '\n'
    }

    install-nixos() {
      temp=$(mktemp -d)
      cleanup() {
        rm -rf "$temp"
      }
      trap cleanup EXIT

      persist="$temp/persist"
      etc="$persist/etc"
      ssh="$etc/ssh"
      luks="/tmp/luks.key"

      mkdir -p "$ssh" && chmod 755 "$ssh"
      sysdecrypt ssh_host_ed25519_key > "$ssh/ssh_host_ed25519_key"
      chmod 600 "$ssh/ssh_host_ed25519_key"

      sysdecrypt machine-id > "$etc/machine-id"
      chmod 644 "$etc/machine-id"

      command nixos-anywhere "root@$ip" \
        --flake ".#$hostname" \
        --build-on-remote -L \
        --extra-files "$temp" \
        --disk-encryption-keys "$luks" <(sysdecrypt luks)
    }
  '';

  packages = with pkgs; [
    coreutils git gh openssh openssl
    rsync helix nil nixos-anywhere
    inputs.agenix.packages.${system}.default
  ];
}