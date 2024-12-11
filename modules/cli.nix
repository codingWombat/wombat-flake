{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.cli;
in
{
  options.codingwombat.cli = {
    enable = mkOption {
      description = "enable cli tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zsh-autosuggestions
      zsh-syntax-highlighting
      btop
      fastfetch
      bottom
      fzf
      bat
      fd
      zoxide
      cheat
      lsd
      starship
    ];
  };
}