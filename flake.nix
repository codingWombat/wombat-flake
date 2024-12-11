{
  description = "System flake for codingwombats devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#codingwombat
    darwinConfigurations."codingwombat" = nix-darwin.lib.darwinSystem {
      inherit inputs;
      system = "aarch64-darwin";
      modules = [ ./hosts/codingwombat/configuration.nix ];
    };
  };
}
