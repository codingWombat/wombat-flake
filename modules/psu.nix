{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.psu;
in
{
  options.codingwombat.psu = {
    enable = mkOption {
      description = "enable psu client";
      type = lib.types.bool;
      default = false;
    };
  };
  
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      nut
    ];
    
    power.ups = {
      enable = true;
      mode = "netclient";
      upsmon = {
        enable = true;
        monitor.main-rack = {
          system = "main-rack@192.168.1.208";
          user = "observer";
          powerValue = 1;
          passwordFile = "/etc/nut/password";
          type = "slave";
        };
      }; 
    };
  };  
}
