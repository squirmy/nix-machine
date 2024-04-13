{...}: {
  nix-machine.configurations.private = {
    options = [./options.nix];
    darwin = [./nix-darwin];
    home = [./home-manager];
  };
}
