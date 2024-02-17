{
  outputs = inputs: {
    flakeModule = ./flake-module.nix;

    templates = {
      minimal = {
        path = ./templates/minimal;
        description = "A basic flake demonstrating the usage of nix-machine in one file";
      };
    };
  };
}
