{inputs}: {
  modules,
  machineConfig,
  machineName,
}: (inputs.nix-darwin.lib.darwinSystem {
  # allow nix-darwin modules to access inputs
  specialArgs = {inherit inputs;};

  # nix-darwin configuration
  modules =
    [
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        # allow home-manager modules to access inputs
        home-manager.extraSpecialArgs = {inherit inputs;};

        home-manager.users.${machineConfig.nix-machine.username} = {
          imports = modules.home ++ [machineConfig];
        };
      }
    ]
    ++ modules.darwin
    ++ [machineConfig];
})
