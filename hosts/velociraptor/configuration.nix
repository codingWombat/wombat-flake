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
    ghostty
  ];

  codingwombat.wombatmin.enable = true;
  codingwombat.clifluff.enable = true;
  codingwombat.clitools.enable = true;
  codingwombat.dev.enable = true;

  hardware.graphics.enable = true;
  virtualisation.vmware.guest.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm.settings.General.DisplayServer = "wayland";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion = "25.05";
}
