{lib, ...}: let
  inherit (lib.attrsets) zipAttrsWith mapAttrsToList;
  inherit (lib.lists) flatten;
  inherit (lib.trivial) pipe;

  resolve = c: let
    resolveProvided = c: c;
    resolveFlat = c: import ./resolve-flat.nix {inherit lib;} c.path;

    resolver =
      if c.path != null && c.scheme == "flat"
      then resolveFlat
      else resolveProvided;
  in
    resolver c;

  # builtins.mapAttrs: Apply function f to every element of attrset.
  resolveAll = configurations: builtins.mapAttrs (name: value: resolve value) configurations;

  # Remove the top level names and zip the values into a new attrset
  # From: { a = { x = 1; y = 2; z = 3; }; b = { x = 4; y = 5; z = 6; }; }
  #   To: { x = [1 4]; y = [2 5]; z = [3 6] }
  combine = c: zipAttrsWith (name: values: flatten values) (mapAttrsToList (name: value: value) c);

  # Allow the options to be used in both nix-darwin and home-manager modules.
  applyOptions = combined: {
    options = combined.options;
    nixDarwin = combined.options ++ combined.nixDarwin;
    homeManager = combined.options ++ combined.homeManager;
  };
in
  configurations:
    pipe configurations [
      resolveAll
      combine
      applyOptions
    ]
