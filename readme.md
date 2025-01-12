###
Rebuilding nixos darwin on a macbook
```shell

darwin-rebuild switch --flake github:codingwombat/wombat-flake#codingwombat
```

### installing a new linux system with hard drive partioning

#### download disk-config.nix via curl
```shell
curl https://raw.githubusercontent.com/codingWombat/wombat-flake/refs/heads/main/hosts/<hostname>/disk-config.nix -o /tmp/disk-config.nix
```

#### execute disko flake to partion harddrive
```shell
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
```

#### generate base nix configuration
```shell
nixos-generate-config --no-filesystems --root /mnt
```

#### install nixos using flakes from github
```shell
sudo nixos-install --root /mnt --flake github:codingwombat/wombat-flake#<hostname>
```