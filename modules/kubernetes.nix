{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.kubernetes;
in
{
  options.codingwombat.kubernetes = {
    enable = mkOption {
      description = "enable kubernetes tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      k9s
      argocd
    ];
  };
}