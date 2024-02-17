{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.nix-machine;

  configurations = map (x: x.value) (lib.attrsets.attrsToList cfg.configurations);

  sharedOptions = lib.catAttrs "options" configurations;
  nixDarwinConfigurations = lib.catAttrs "nixDarwin" configurations;
  homeManagerConfigurations = lib.catAttrs "homeManager" configurations;

  # Share the options between nix-darwin and home-manager so that they can be
  # configured in a way that is agnostic to the where the configuration applies.
  nixDarwinConfiguration = {imports = sharedOptions ++ nixDarwinConfigurations;};
  homeManagerConfiguration = {imports = sharedOptions ++ homeManagerConfigurations;};

  configurationOptions = {
    options = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
    };
    nixDarwin = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
    };
    homeManager = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
    };
  };
in {
  options.nix-machine.configurations = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {options = configurationOptions;});
    default = {};
  };

  options.nix-machine.macos = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = sharedOptions;
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
            modules = [
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                # allow home-manager modules to access inputs
                home-manager.extraSpecialArgs = specialArgs;

                home-manager.users.${machineConfiguration.nix-machine.username} = {
                  imports = [homeManagerConfiguration machineConfiguration];
                };
              }
              nixDarwinConfiguration
              machineConfiguration
            ];
          })
        )
        cfg.macos;
    };
  };
}
