{...}: {
  nix-machine.configurations.private = {
    nixDarwin = ./nix-darwin;
    homeManager = ./home-manager;
  };
}
