{
  lib,
  flakeLib,
}: let
  config = flakeLib.config.merge {
    squirmy = {
      path = ../_fixture/by-name-config;
      scheme = "by-name";
    };
  };

  testOptions = {lib, ...}: {
    options.names = lib.mkOption {
      type = lib.types.lines;
    };
  };

  eval = lib.evalModules {
    modules = [testOptions] ++ config.darwin;
  };
in {
  inherit (eval) options config;
}
