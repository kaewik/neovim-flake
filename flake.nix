{
  inputs.neovim-flake.url = "github:jordanisaacs/neovim-flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.copilot.url = "github:github/copilot.vim/release";
  inputs.copilot.flake = false;

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    neovim-flake,
    copilot,
    ...
  }: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        configModule = {
          # Add any custom options (and feel free to upstream them!)
          # options = ...
          config.build.rawPlugins = {
            copilot.src = copilot;
          };
          config.vim.theme.enable = true;
          config.vim.startPlugins = ["copilot"];
        };

      in {
        packages = rec {
          customNeovim = neovim-flake.lib.neovimConfiguration {
            modules = [configModule];
            inherit pkgs;
          };
          neovim = customNeovim;
        };
        apps = rec {
          neovim = flake-utils.lib.mkApp { drv = self.packages.${system}.neovim; };
        };
      });
}
