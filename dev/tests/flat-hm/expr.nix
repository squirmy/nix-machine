{
  lib,
  flakeLib,
}: let
  config = flakeLib.config.merge {
    squirmy = {
      path = ../_fixture/flat-config;
      scheme = "flat";
    };
  };

  testOptions = {lib, ...}: {
    options.names = lib.mkOption {
      type = lib.types.lines;
    };
  };

  inherit (config) homeManager;

  eval = lib.evalModules {
    modules = [testOptions] ++ homeManager;
  };
in {
  inherit (eval) options config;
}
