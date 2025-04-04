{lib, ...}: let
  # Credit: https://github.com/reckenrode
  # https://github.com/reckenrode/nixos-configs/blob/main/modules/top-level/all-modules.nix
  enumerateModules = basePath: fileName: let
    inherit (builtins) readDir;
    inherit (lib) attrNames concatMap elemAt filter filterAttrs pathExists substring toLower foldl';
    inherit (lib.trivial) pipe;

    childPaths = path: attrNames (filterAttrs (_: type: type == "directory") (readDir path));
    isShardedCorrectly = path: elemAt path 0 == toLower (substring 0 2 (elemAt path 1));
    mkPath = shard: package: [shard package "${fileName}.nix"];
    modulesInShard = shard: map (mkPath shard) (childPaths (basePath + "/${shard}"));
    renderPath = foldl' (path: elem: path + "/${elem}");
  in
    pipe (childPaths basePath) [
      (concatMap modulesInShard)
      (filter isShardedCorrectly)
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
