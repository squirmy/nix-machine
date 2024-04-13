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

  eval = lib.evalModules {
    modules = [testOptions] ++ config.home;
  };
in {
  inherit (eval) options config;
}
