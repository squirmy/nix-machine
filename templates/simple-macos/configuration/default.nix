{...}: {
  nix-machine.configurations.private = {
    darwin = ./nix-darwin;
    home = ./home-manager;
  };
}
