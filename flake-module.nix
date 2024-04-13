{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.nix-machine;

  mergedConfig = import ./lib/config/merge.nix {inherit lib;} cfg.configurations;

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
      modules = mergedConfig.options;
    });
    default = {};
  };

  imports = [./configuration];

  config = let
    specialArgs = import ./lib/special-args.nix {inherit inputs;};
  in {
    flake = {
      darwinConfigurations =
        builtins.mapAttrs (
          _machineName: machineConfiguration: (inputs.nix-darwin.lib.darwinSystem {
            # allow nix-darwin modules to access inputs
            inherit specialArgs;

            # nix-darwin configuration
            modules =
              [
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  # allow home-manager modules to access inputs
                  home-manager.extraSpecialArgs = specialArgs;

                  home-manager.users.${machineConfiguration.nix-machine.username} = {
                    imports = mergedConfig.home ++ [machineConfiguration];
                  };
                }
              ]
              ++ mergedConfig.darwin
              ++ [machineConfiguration];
          })
        )
        cfg.macos;
    };
  };
}
