{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.clifluff;
in
{
  options.codingwombat.clifluff = {
    enable = mkOption {
      description = "enable cli fluff";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zsh-autosuggestions
      zsh-syntax-highlighting
      starship
    ];
  };
}