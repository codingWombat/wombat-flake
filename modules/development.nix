{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  cfg = config.codingwombat.dev;
in
{
  options.codingwombat.dev = {
    enable = mkOption {
      description = "enable dev tooling";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # nix lsp
      nixd
      # java
      temurin-bin-23
      # dotnet
      dotnet-sdk_9
      # rust
      rustup
      # editor
      helix
    ];
  };
}