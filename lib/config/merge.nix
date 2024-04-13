{
  lib,
  flakeLib,
  ...
}: let
  inherit (lib.attrsets) zipAttrsWith mapAttrsToList;
  inherit (lib.lists) flatten;
  inherit (lib.trivial) pipe;

  # builtins.mapAttrs: Apply function f to every element of attrset.
  resolveAll = configurations: builtins.mapAttrs (_name: value: flakeLib.config.resolve value) configurations;

  # Remove the top level names and zip the values into a new attrset
  # From: { a = { x = 1; y = 2; z = 3; }; b = { x = 4; y = 5; z = 6; }; }
  #   To: { x = [1 4]; y = [2 5]; z = [3 6] }
  combine = c: zipAttrsWith (_name: values: flatten values) (mapAttrsToList (_name: value: value) c);
in
  configurations:
    pipe configurations [
      resolveAll
      combine
    ]
