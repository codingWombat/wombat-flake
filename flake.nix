{
  description = "System flake for codingwombats devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, disko }
  @inputs:
  let
    modules = [(import ./modules/default.nix)];
    linuxModules = [(import ./modules/linux.nix)];
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
      modules = [ ./hosts/velociraptor/configuration.nix
        ./hosts/velociraptor/disk-config.nix
        disko.nixosModules.disko
      ] ++ modules ++ linuxModules;
      specialArgs = { inherit inputs; inherit publicKeys; };
    };

    nixosConfigurations."triceratops" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/triceratops/configuration.nix
        ./hosts/triceratops/disk-config.nix
        disko.nixosModules.disko
      ] ++ modules ++ linuxModules;
      specialArgs = { inherit inputs; inherit publicKeys; };
    };
  };
}
