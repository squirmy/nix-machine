{
  outputs = inputs: {
    flakeModule = ./flake-module.nix;

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
