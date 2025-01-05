{ pkgs, lib, config, publicKeys, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.wombatmin;
in
{

  options.codingwombat.wombatmin = {
    enable = mkOption {
      description = "create wombatmin";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable
    {
      #Set some system wide options
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
      };

      users.users.wombatmin = {
        isNormalUser = true;
        extraGroups  = [ "wheel" "networkmanager" ];
        openssh.authorizedKeys.keys = publicKeys;
        shell = pkgs.zsh;
      };

      programs.git.config = {
        user.name = "codingWombat";
        user.email = "main@codingwombat.dev";
      };
    };
}
