#!/bin/bash -ex
package_indices=$(nix profile list | grep neovim-flake | cut -d ' ' -f 1)
echo $package_indices
for idx in $package_indices; do
    nix profile remove $idx
done
nix profile install .#
