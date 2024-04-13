{lib, ...}: c: let
  # todo; break backwards compatibility and just return c
  resolveProvided = c: {
    options = c.options;
    darwin = c.nixDarwin;
    home = c.homeManager;
  };

  resolveFlat = c: import ./resolve-flat.nix {inherit lib;} c.path;

  resolver =
    if c.path != null && c.scheme == "flat"
    then resolveFlat
    else resolveProvided;
in
  resolver c
