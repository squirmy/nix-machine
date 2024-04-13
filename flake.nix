{
  inputs = {
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = inputs: let
    lib = {
      config.merge = import ./lib/config/merge.nix {inherit (inputs.nixpkgs) lib;};
      config.resolve = import ./lib/config/resolve.nix {inherit (inputs.nixpkgs) lib;};
      systems.darwin = import ./lib/systems/darwin.nix;
    };
  in {
    flakeModule = import ./flake-module.nix {flakeLib = lib;};

    inherit lib;

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
