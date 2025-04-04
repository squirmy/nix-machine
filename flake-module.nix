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
  linuxSystem = flakeLib.systems.linux {inherit inputs;};
  darwinSystem = flakeLib.systems.darwin {inherit inputs;};

  asLinuxConfiguration = _machineName: machineConfig: (linuxSystem {
    inherit modules;
    inherit machineConfig;
  });

  asDarwinConfiguration = _machineName: machineConfig: (darwinSystem {
    inherit modules;
    inherit machineConfig;
  });

  configurationOptions = {
    options = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [];
    };
    nixos = lib.mkOption {
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

  options.nix-machine.linux = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = modules.options;
    });
    default = {};
  };

  imports = [./configuration];

  config.flake.nix-machine.lib = {
    mkDarwinMachine = asDarwinConfiguration "_";
    mkLinuxMachine = asLinuxConfiguration "_";
  };

  config.flake.nixosConfigurations = builtins.mapAttrs asLinuxConfiguration cfg.linux;
  config.flake.darwinConfigurations = builtins.mapAttrs asDarwinConfiguration cfg.macos;
}
