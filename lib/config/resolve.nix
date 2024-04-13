{lib, ...}: c: let
  resolveProvided = c: c;
  resolveFlat = c: import ./resolve-flat.nix {inherit lib;} c.path;
  resolveByName = c: import ./resolve-by-name.nix {inherit lib;} c.path;

  resolver =
    if c.path != null && c.scheme == "flat"
    then resolveFlat
    else if c.path != null && c.scheme == "by-name"
    then resolveByName
    else resolveProvided;
in
  resolver c
