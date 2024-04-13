{lib, ...}: let
  inherit (lib.attrsets) zipAttrsWith mapAttrsToList;
  inherit (lib.lists) flatten;
  inherit (lib.trivial) pipe;

  resolve = c: import ./resolve.nix {inherit lib;} c;

  # builtins.mapAttrs: Apply function f to every element of attrset.
  resolveAll = configurations: builtins.mapAttrs (name: value: resolve value) configurations;

  # Remove the top level names and zip the values into a new attrset
  # From: { a = { x = 1; y = 2; z = 3; }; b = { x = 4; y = 5; z = 6; }; }
  #   To: { x = [1 4]; y = [2 5]; z = [3 6] }
  combine = c: zipAttrsWith (name: values: flatten values) (mapAttrsToList (name: value: value) c);

  # todo; optionally apply the options in resolve to allow resolve to be used independently
  # Allow the options to be used in both nix-darwin and home-manager modules.
  applyOptions = combined: {
    options = combined.options;
    darwin = combined.options ++ combined.darwin;
    home = combined.options ++ combined.home;
  };
in
  configurations:
    pipe configurations [
      resolveAll
      combine
      applyOptions
    ]
