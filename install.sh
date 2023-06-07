#!/bin/bash -ex
package_indices=$(nix profile list | grep neovim-flake | cut -d ' ' -f 1)
nix profile remove $package_indices
nix profile install .#
