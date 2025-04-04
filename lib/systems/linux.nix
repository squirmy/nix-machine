{...}: {inputs, ...}: {
  modules,
  machineConfig,
  ...
}: (inputs.nixpkgs.lib.nixosSystem {
  # allow nixos modules to access inputs
  specialArgs = {inherit inputs;};

  # nixos configuration
  modules =
    [
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
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
    ++ modules.nixos
    ++ [machineConfig];
})
