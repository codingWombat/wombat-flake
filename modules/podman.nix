{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.podman;
in
{
  options.codingwombat.podman = {
    enable = mkOption {
      description = "enable podman tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman
      # podman-desktop
      podman-compose
    ];
  };
}
