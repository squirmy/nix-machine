# nix-machine

A convenience flake for configuring your machine using nix-darwin and home-manager.

## Getting Started

### 1. Install Nix

- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) (recommended)
- [Official Nix Installer](https://nixos.org/download)

See the [motivations](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#motivations) section of the Determinate Nix Installer section of the for more details.

### 2. Create your nix configuration flake

Create a new configuration by running the following command:

`nix flake new --template .#simple-macos nixos-config`

This will create a new directory named `nixos-config` with the contents of [templates/simple-macos](./templates/simple-macos). This template is perfect if you're just starting out or have just one machine that you wish to configure.

You must update the `nix-machine` configuration in `flake.nix`:

```nix
{
  nix-machine.macos."hostname" = {
    nix-machine = {
      username = "username";
      homeDirectory = "/Users/username";
      nixpkgs.hostPlatform = "aarch64-darwin";
      shells.zsh.enable = true;
    };
  };
}
```

Guidance:

1. `hostname` is the name of your machine. It can be any name you choose, but it is convenient to use the hostname of your machine.
2. `username` must be set to your username. For the current user this is the value of `$USER`.
3. `homeDirectory` must be set to your user's home directory. For the current user this is the value of `$HOME`.
4. `nixpkgs.hostPlatform` must be set to either:
   - `aarch64-darwin` for apple sillicon.
   - `x86_64-darwin` for intel based macs.
5. `shells.zsh.enable` keep this as true if you wish to use zsh. If not, remove this line and add your own shell configuration. Other shells are not yet supported in `nix-machine`.

### 3. Apply the configuration

The following command will build the flake and apply it to your machine. If `nix-darwin` or `home-manager` ask you to backup any files, follow the instructions and rename them. Then run the command again.

If you used your current machine's hostname as the machine name you can run:

```bash
# Replace hostname with the name of your machine:
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#hostname

# Can be used if you named your machine the same as your hostname
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#"$(hostname -s)"
```

Restart your shell session.

### 4. Configure your machine

You can now slowly iterate on your configuration by adding `nix-darwin` and `home-manager` configuration. After adding new configuration, you'll need to apply the configuration by running the above command again.

- Configure [nix-darwin options](https://daiderd.com/nix-darwin/manual/index.html) in `configuration/nix-darwin`.
- Configure [home-manager options](https://mipmip.github.io/home-manager-option-search/) in `configuration/home-manager`.

My [nixos-config](https://github.com/squirmy/nixos-config) can be used as an example.

## Motivations

- Reduce boilerplate by providing sensible default values for nix, nixpkgs, nix-darwin and home-manager.
- Encourage nix-darwin and home-manager configuration re-use. Share configurations between your own machines, and optionally expose it as a flake module to share with others.
