echo "System text files:"
du -sh /etc/nixos/

echo "Evaluated configurations:"
nix path-info -sh /run/current-system

echo "The Accumulation of all saved configurations:"
nix-env --profile /nix/var/nix/profiles/system --list-generations
