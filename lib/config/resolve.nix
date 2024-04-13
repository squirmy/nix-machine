{lib, ...}: c: let
  inherit (lib.trivial) pipe;

  resolveProvided = c: c;
  resolveFlat = c: import ./resolve-flat.nix {inherit lib;} c.path;
  resolveByName = c: import ./resolve-by-name.nix {inherit lib;} c.path;

  resolver =
    if c.path != null && c.scheme == "flat"
    then resolveFlat
    else if c.path != null && c.scheme == "by-name"
    then resolveByName
    else resolveProvided;

  # Allow the options to be used in both nix-darwin and home-manager modules.
  applyOptions = c: {
    options = c.options;
    darwin = c.options ++ c.darwin;
    home = c.options ++ c.home;
  };
in
  pipe c [
    resolver
    applyOptions
  ]
