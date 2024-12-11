{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.darwinConfig = inputs.self + /hosts/codingwombat/configuration.nix;

  codingwombat.cli.enable = true;

  environment.systemPackages =
          [
            # nix lsp
            pkgs.nixd
            # zsh plugins
            pkgs.zsh-autosuggestions
            pkgs.zsh-syntax-highlighting

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

  security.pam.enableSudoTouchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}