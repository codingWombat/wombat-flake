{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  boot.initrd.kernelModules = ["i915"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {    
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver
      intel-ocl
      intel-vaapi-driver
      vpl-gpu-rt
      mesa.drivers
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; };

  environment.systemPackages = with pkgs; [
    helix
    intel-gpu-tools
  ];

  codingwombat.wombatmin.enable = true;
  codingwombat.clitools.enable = true;
  codingwombat.server.enable = true;

  networking.useDHCP = true;

  networking = {
    hostName = "triceratops";
    firewall = {
        allowedTCPPorts = [];
        checkReversePath = "loose";
    };
    nameservers = ["1.1.1.1" "9.9.9.9"];
    defaultGateway = {
      address = "192.168.111.1";
      interface = "enp12s0";
    };

    ## 1gig nic
    interfaces.enp12s0 = {
      useDHCP = false;
      ipv4.addresses = [{
          address = "192.168.111.11";
          prefixLength = 24;
      }];
    };
    interfaces.enp13s0 = {
      useDHCP = false;
      ipv4.addresses = [{
          address = "192.168.111.12";
          prefixLength = 24;
      }];
    };

    ## 2.5 gig nics
    bonds."bond-10" = {
      interfaces = ["ens1" "ens9" "enp5s0" "enp6s0"];
      driverOptions = {
        mode = "802.3ad";
        xmit_hash_policy = "layer3+4";
      };
    };

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


  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
