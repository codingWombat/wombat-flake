{
  pkgs,
  inputs,
  ...
}:
{
  boot.initrd.kernelModules = [ "i915" ];
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
    extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      intel-vaapi-driver
      vpl-gpu-rt
      mesa.drivers
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  # install haos as vm
  # sudo virt-install --connect qemu:///system --name haos --description "Home Assistant OS" --os-variant=generic --ram=4096 --vcpus=2 --disk /opt/data/vms/haos_ova-14.2.qcow2,bus=scsi --controller type=scsi,model=virtio-scsi --import --graphics "spice,listen=0.0.0.0" --network network=bridged-network --boot uefi
  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot of Home Assistant OS guest image
      qemu.ovmf.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    helix
    intel-gpu-tools
    beszel
    virt-manager
    usbutils
  ];

  codingwombat.wombatmin.enable = true;
  codingwombat.clitools.enable = true;
  codingwombat.server.enable = true;
  codingwombat.k3shost.enable = true;
  codingwombat.beszel.enable = true;
  codingwombat.beszel-agent = {
    enable = true;
    extraFilesystems = [ "/opt/data" ];
    gpu = true;
  };
  codingwombat.psu.enable = true;

  networking.useDHCP = true;

  networking = {
    hostName = "triceratops";
    firewall = {
      allowedTCPPorts = [
        5900
        8123
      ];
      checkReversePath = "loose";
    };
    nameservers = [
      "192.168.111.1"
      "1.1.1.1"
      "9.9.9.9"
    ];
    defaultGateway = {
      address = "192.168.111.1";
      interface = "enp12s0";
    };

    ## 1gig nic
    ### main
    interfaces.enp12s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.11";
          prefixLength = 24;
        }
      ];
    };

    bridges.br0.interfaces = [ "enp13s0" ];

    ### hass os vm
    interfaces.br0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.12";
          prefixLength = 24;
        }
      ];
    };

    ## 2.5 gig nics
    ### kube metallb
    interfaces.ens1 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.18";
          prefixLength = 24;
        }
      ];
    };

    interfaces.ens9 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.25";
          prefixLength = 24;
        }
      ];
    };

    interfaces.enp5s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.26";
          prefixLength = 24;
        }
      ];
    };

    interfaces.enp6s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.111.27";
          prefixLength = 24;
        }
      ];
    };
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
