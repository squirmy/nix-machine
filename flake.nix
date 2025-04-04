{
  inputs = {
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = inputs: let
    # Use dependency injection instead of importing the
    # lib function files directly
    init = path: (import path {
      lib = inputs.nixpkgs.lib;
      flakeLib = lib;
    });

    lib = {
      config.merge = init ./lib/config/merge.nix;
      config.resolve = init ./lib/config/resolve.nix;
      config.resolveFlat = init ./lib/config/resolve-flat.nix;
      config.resolveByName = init ./lib/config/resolve-by-name.nix;
      systems.darwin = init ./lib/systems/darwin.nix;
      systems.linux = init ./lib/systems/linux.nix;
    };
  in {
    flakeModule = init ./flake-module.nix;

    lib = lib;

    templates = {
      minimal = {
        path = ./templates/minimal;
        description = "A basic flake demonstrating the usage of nix-machine in one file";
      };
      simple-macos = {
        path = ./templates/simple-macos;
        description = "The simplest viable template. Use this to start.";
      };
    };
  };
}
