###
Rebuilding nixos darwin on a macbook
```shell

darwin-rebuild switch --flake github:codingwombat/wombat-falke#codingwombat
```

### installing a new linux system with hard drive partioning

```shell

# Assuming
# - your system is x86_64-linux
FLAKE="github:codingwombat/wombat-falke#<hostname>"
DISK_DEVICE=<hard-disk-path>
sudo nix \
--extra-experimental-features 'flakes nix-command' \
run github:nix-community/disko#disko-install -- \
--flake "$FLAKE" \
--write-efi-boot-entries \
--disk main "$DISK_DEVICE"
```