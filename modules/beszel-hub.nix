{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.codingwombat.beszel-hub;
in {
  options.codingwombat.beszel-hub = {
    enable = mkEnableOption "Beszel hub service";

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User account under which the service runs.";
    };

    groups = mkOption {
      type = types.listOf types.str;
      default = ["root"];
      description = "Groups under which the service runs.";
    };

    restartSec = mkOption {
      type = types.int;
      default = 5;
      description = "Time to wait before restarting the service.";
    };

  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
          8090
    ];

    environment.systemPackages = with pkgs; [
      beszel
    ];

    systemd.services.beszel-hub = {
      description = "Beszel Agent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/beszel server --http \"0.0.0.0:8090\"";
        User = cfg.user;
        Group = builtins.head cfg.groups;
        Restart = "always";
        RestartSec = cfg.restartSec;
      };
    };
  };
}