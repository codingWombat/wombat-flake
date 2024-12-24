{ publicKeys, lib, config, ... }:
with lib;
let
  cfg = config.codingwombat.user;
in
{

  options.codingwombat.user = {
    enable = mkOption {
      description = "create wombatmin";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable
    {
      # Set some system wide options
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
      };

      users.users.wombatmin = {
        openssh.authorizedKeys.keys = publicKeys;
      };
    };
}