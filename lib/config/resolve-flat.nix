{lib, ...}: let
  enumerateModules = basePath: fileName: let
    inherit (builtins) readDir;
    inherit (lib) attrNames filter filterAttrs pathExists foldl';
    inherit (lib.trivial) pipe;

    packagePaths = path: attrNames (filterAttrs (_: type: type == "directory") (readDir path));
    modulesInPackage = package: [package "${fileName}.nix"];
    renderPath = foldl' (path: elem: path + "/${elem}");
  in
    pipe (packagePaths basePath) [
      (map modulesInPackage)
      (map (renderPath basePath))
      (filter pathExists)
    ];
in
  path: {
    options = enumerateModules path "options";
    nixos = enumerateModules path "nixos-module";
    darwin = enumerateModules path "darwin-module";
    home = enumerateModules path "hm-module";
  }
