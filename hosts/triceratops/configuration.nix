{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  boot.loader = {    
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    helix
  ];

  codingwombat.wombatmin.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
