{lib, ...}: let
  enumerateModules = basePath: fileName: let
    inherit (builtins) readDir;
    inherit (lib) attrNames filter filterAttrs pathExists foldl';
    inherit (lib.trivial) pipe;

    packagePaths = path: attrNames (filterAttrs (_: type: type == "directory") (readDir path));
    modulesInPackage = package: [package "${fileName}.nix"];
    renderPath = foldl' (path: elem: path + "/${elem}");

    modules = pipe (packagePaths basePath) [
      (map modulesInPackage)
      (map (renderPath basePath))
      (filter pathExists)
    ];
  in
    {...}: {
      imports = modules;
    };

  importConfig = path: let
    createModule = enumerateModules path;
  in {
    options = createModule "options";
    nixDarwin = createModule "darwin-module";
    homeManager = createModule "hm-module";
  };

  # If a path is specified,
  main = configuration:
    if configuration.path != null && configuration.scheme == "flat"
    then importConfig configuration.path
    else configuration;
in
  configurations: builtins.mapAttrs (c: v: main v) configurations
