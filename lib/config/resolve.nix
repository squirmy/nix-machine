{lib, ...}: c: let
  resolveProvided = c: c;
  resolveFlat = c: import ./resolve-flat.nix {inherit lib;} c.path;

  resolver =
    if c.path != null && c.scheme == "flat"
    then resolveFlat
    else resolveProvided;
in
  resolver c
