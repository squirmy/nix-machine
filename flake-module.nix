{
  lib,
  flakeLib,
  ...
}: {
  inputs,
  config,
  ...
}: let
  cfg = config.nix-machine;

  modules = flakeLib.config.merge cfg.configurations;
  darwinSystem = flakeLib.systems.darwin {inherit inputs;};

  asDarwinConfiguration = _machineName: machineConfig: (darwinSystem {
    inherit modules;
    inherit machineConfig;
  });

  configurationOptions = {
    options = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [];
    };
    darwin = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [];
    };
    home = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [];
    };
    path = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
    scheme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
in {
  options.nix-machine.configurations = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {options = configurationOptions;});
    default = {};
  };

  options.nix-machine.macos = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = modules.options;
    });
    default = {};
  };

  imports = [./configuration];

  config.flake.nix-machine.lib = {
    mkDarwinMachine = asDarwinConfiguration "_";
  };

  config.flake.darwinConfigurations = builtins.mapAttrs asDarwinConfiguration cfg.macos;
}
