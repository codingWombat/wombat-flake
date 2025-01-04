{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.server;
in
{
  options.codingwombat.server = {
    enable = mkOption {
      description = "enable clitools tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}