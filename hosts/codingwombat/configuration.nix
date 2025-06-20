{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.darwinConfig = inputs.self + /hosts/codingwombat/configuration.nix;

  codingwombat.clifluff.enable = true;
  codingwombat.clitools.enable = true;
  codingwombat.kubernetes.enable = true;
  codingwombat.podman.enable = true;
  codingwombat.dev.enable = true;

  environment.systemPackages = with pkgs; [
    vlc-bin
    toot
    nushell
    sniffnet
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

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
