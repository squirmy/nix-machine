{...}: {
  nix-machine.configurations.private = {
    options = ./options.nix;
    nixDarwin = ./nix-darwin;
    homeManager = ./home-manager;
  };
}
