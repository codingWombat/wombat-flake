{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.k3shost;
in
{
  options.codingwombat.k3shost = {
    enable = mkOption {
      description = "enable k3s";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      6443 80 443
    ];
    networking.firewall.allowedUDPPorts = [
      51820
    ];
    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
      "--disable traefik"
      "--disable servicelb"
      "--write-kubeconfig-group wheel"
      "--write-kubeconfig-mode 640"
      "--kube-proxy-arg=ipvs-strict-arp=true"
      "--flannel-backend wireguard-native"
      "--flannel-iface=ens1"
      "--node-name triceratops"
      "--bind-address 192.168.111.18"
      "--node-ip 192.168.111.18"
      "--advertise-address 192.168.111.18"
    ];
  };
}
