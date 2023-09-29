#!/bin/bash -ex
neovim_store_paths=$(nix profile list --json | jq -r '.elements[] | select(.originalUrl | contains("neovim")) | .storePaths[]')
while IFS= read -r store_paths; do
    nix profile remove $store_paths
done <<< "$neovim_store_paths"
nix profile install .#
