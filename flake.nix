{
  inputs.neovim-flake.url = "github:jordanisaacs/neovim-flake";

  inputs.copilot.url = "github:github/copilot.vim/release";
  inputs.copilot.flake = false

  outputs = {
    nixpkgs,
    neovim-flake,
    copilot,
    ...
  }: let
    system = "x86_64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    configModule = {
    # Add any custom options (and feel free to upstream them!)
    # options = ...

      config.buil.rawPlugins = [copilot]
      config.vim.theme.enable = true;
    };

    customNeovim = neovim-flake.lib.neovimConfiguration {
      modules = [configModule];
      inherit pkgs;
    };
  in {
    packages.${system}.neovim = customNeovim;
  };
}
