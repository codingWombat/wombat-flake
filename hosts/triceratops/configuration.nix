{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  boot.loader = {    
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    helix
  ];

  codingwombat.wombatmin.enable = true;
  codingwombat.clitools.enable = true;
  codingwombat.server.enable = true;

  services.tailscale.enable = true;
  networking.hostName = "triceratops";

  systemd.network.enable = true;

  systemd.network.networks = {
    "10-1gig-enp12s0" = {
      matchConfig.name = "enp12s0";
      address = [
        "192.168.111.11/24"
      ];
      routes = [
        {Gateway = "192.168.11.1"; }
      ];
      linkConfig.RequiredForOnline = "routeable";
    };

    "20-1gig-enp13s0" = {
      matchConfig.name = "enp13s0";
      address = [
        "192.168.111.12/24"
      ];
      routes = [
        {Gateway = "192.168.11.1"; }
      ];
      linkConfig.RequiredForOnline = "routeable";
    };

  };

  networking = {
#    hostName = "triceratops";
    firewall = {
        allowedTCPPorts = [];
        checkReversePath = "loose";
    };
    nameservers = ["192.168.111.1" "1.1.1.1" "9.9.9.9"];
    ## 1gig nics
#    interfaces.enp12s0 = {
#      ipv4.addresses = [{
#          address = "192.168.111.11";
#          prefixLength = 24;
#      }];
#    };
#    interfaces.enp13s0 = {
#      ipv4.addresses = [{
#          address = "192.168.111.12";
#          prefixLength = 24;
#      }];
#    };
#    ### 2.5 gig nics
#    interfaces.ens1 = {
#      ipv4.addresses = [{
#          address = "192.168.111.13";
#          prefixLength = 24;
#      }];
#    };
#    interfaces.ens9 = {
#      ipv4.addresses = [{
#          address = "192.168.111.14";
#          prefixLength = 24;
#      }];
#    };
#    interfaces.enp5s0 = {
#      ipv4.addresses = [{
#          address = "192.168.111.15";
#          prefixLength = 24;
#      }];
#    };
#    interfaces.enp6s0 = {
#      ipv4.addresses = [{
#          address = "192.168.111.16";
#          prefixLength = 24;
#      }];
#    };

#    defaultGateway = {
#      address = "192.168.111.1";
#      interface = "enp12s0";
#    };
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
