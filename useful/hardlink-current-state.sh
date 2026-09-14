# creates hardlink for current nixos state
PATH="${1:-"~/my-safe-nixos-backup"}"
ln -s /nix/var/nix/profiles/system-current-link $PATH

