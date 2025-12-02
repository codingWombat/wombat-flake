{
  description = "System flake for codingwombats devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-substituters = [ "https://cache.soopy.moe" ];
    extra-substituters = [ "https://cache.soopy.moe" ];
    extra-trusted-public-keys = [ "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=" ];
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      nixos-hardware,
      disko,
    }@inputs:
    let
      modules = [ (import ./modules/default.nix) ];
      linuxModules = [ (import ./modules/linux.nix) ];
      t2Modules = [ (import ./mmodules/t2.nix) ];
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5hep9vnJDpydFRLwJhBkwEFSWeA7jLrHAS+liNcasc codingwombat@MacBook-Pro.localdomain"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+wFxNm9hmOYgNkBNH0MU0WBjvY9B1Eff0aYUN4P/t8 workwombat"
      ];
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#codingwombat
      darwinConfigurations."codingwombat" = nix-darwin.lib.darwinSystem {
        inherit inputs;
        system = "aarch64-darwin";
        modules = [ ./hosts/codingwombat/configuration.nix ] ++ modules;
      };

      nixosConfigurations."velociraptor" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/velociraptor/configuration.nix
          ./hosts/velociraptor/disk-config.nix
          disko.nixosModules.disko
        ]
        ++ modules
        ++ linuxModules;
        specialArgs = {
          inherit inputs;
          inherit publicKeys;
        };
      };

      nixosConfigurations."triceratops" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/triceratops/configuration.nix
          ./hosts/triceratops/disk-config.nix
          disko.nixosModules.disko
        ]
        ++ modules
        ++ linuxModules;
        specialArgs = {
          inherit inputs;
          inherit publicKeys;
        };
      };

      nixosConfigurations."stegosaurus" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/stegosaurus/configuration.nix
          nixos-hardware.nixosModules.apple-t2
        ]
        ++ modules
        ++ t2Modules;
        specialArgs = {
          inherit inputs;
          inherit publicKeys;
        };
      };
    };
}
