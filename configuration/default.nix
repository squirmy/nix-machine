{...}: {
  nix-machine.configurations.nix-machine = {
    options = [./options.nix];
    darwin = [./nix-darwin];
    home = [./home-manager];
  };
}
