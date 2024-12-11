{
  description = "System flake for codingwombats macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          # zsh plugins
          pkgs.zsh-autosuggestions
          pkgs.zsh-syntax-highlighting
          # cli tools
          pkgs.fastfetch
          pkgs.bottom
          pkgs.fzf
          pkgs.bat
          pkgs.fd
          pkgs.zoxide
          pkgs.cheat
          pkgs.lsd
          pkgs.starship
          # kubernetes
          pkgs.kubectl
          pkgs.kubernetes-helm
          pkgs.k9s
          pkgs.argocd
          # podman
          pkgs.podman
          pkgs.podman-desktop
          pkgs.podman-compose
          # java
          pkgs.temurin-bin-23
          # dotnet
          pkgs.dotnet-sdk_9
          # Rust
          pkgs.rustup
          # helix
          pkgs.helix            
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#codingwombat
    darwinConfigurations."codingwombat" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
