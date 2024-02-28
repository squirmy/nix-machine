# nix-machine

A convenience flake for configuring your machine using nix-darwin and home-manager.

Why:

- Reduces boilerplate by providing sensible default values for nix, nixpkgs, nix-darwin and home-manager.
- Encourages nix-darwin and home-manager configuration re-use. Share your configurations between your own machines, and optionally expose it as a flake module to share with others.

A minimal example can be found in [templates/minimal](./templates/minimal/flake.nix).

A more sustainable folder structure can be found in [templates/private-configuration](./templates/private-configuration/flake.nix).

An example showing how to expose your configuration as a flake module can be found in [templates/expose-configuration](./templates/expose-configuration/flake.nix).

My [nixos-config](https://github.com/squirmy/nixos-config) can also be used as an example.
