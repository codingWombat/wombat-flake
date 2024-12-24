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
    publicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5hep9vnJDpydFRLwJhBkwEFSWeA7jLrHAS+liNcasc codingwombat@MacBook-Pro.localdomain"
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

    nixOsConfiguration."antman" = nixpkgs.lib.nixosSystem {
      inherit inputs;
      inherit publicKeys;
      system = "x86_64-linux";
      modules = [ ./hosts/antman/configuration.nix
        ./hosts/antman/disk-config.nix
        disko.nixosModules.disko
      ];
    };
  };
}
