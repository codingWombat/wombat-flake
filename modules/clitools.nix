{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.clitools;
in
{
  options.codingwombat.clitools = {
    enable = mkOption {
      description = "enable clitools tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
      fastfetch
      bottom
      fzf
      bat
      fd
      zoxide
      cheat
      lsd
    ];
  };
}