{
  pkgs,
  inputs,
  ...
}:
{
  #boot.loader.grub.enable = true;
  #boot.loader.grub.efiSupport = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    helix
    kitty
  ];

  programs.hyprland.enable = true;
  codingwombat.wombatmin.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion = "25.05";
}
