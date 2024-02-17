# nix-machine

A convenience flake for configuring your machine using nix-darwin and home-manager.

Why:

- Reduces boilerplate by providing sensible default values for nix, nixpkgs, nix-darwin and home-manager.
- Encourages nix-darwin and home-manager configuration re-use. Share your configurations between your own machines, and optionally expose it as a flake module to share with others.

A minimal example can be found in [templates/minimal](./templates/minimal/flake.nix).
