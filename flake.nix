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
          config.build = {
            viAlias = false;
            vimAlias = true;
            rawPlugins = {
              copilot.src = copilot;
            };
          };
          config.vim = {
            startPlugins = ["copilot"];
            disableArrows = true;
            languages = {
              enableLSP = false;
              enableFormat = true;
              enableTreesitter = true;
              enableExtraDiagnostics = false;

              nix.enable = true;
              markdown.enable = true;
              html.enable = true;
              clang.enable = true;
              sql.enable = true;
              rust = {
                enable = true;
                crates.enable = true;
              };
              ts.enable = true;
              go.enable = true;
              zig.enable = true;
              python.enable = true;
              plantuml.enable = true;
              #java.enable = true;
              #kotlin.enable = true;
              #terraform.enable = true;

              # See tidal config
              tidal.enable = false;
            };
            lsp = {
              formatOnSave = false;
              lspkind.enable = false;
              lightbulb.enable = false;
              lspsaga.enable = false;
              nvimCodeActionMenu.enable = false;
              trouble.enable = false;
              lspSignature.enable = false;
            };
            visuals = {
              enable = true;
              nvimWebDevicons.enable = true;
              indentBlankline = {
                enable = true;
                fillChar = null;
                eolChar = null;
                showCurrContext = true;
              };
              cursorWordline = {
                enable = true;
                lineTimeout = 0;
              };
            };
            statusline.lualine.enable = true;
            theme.enable = true;
            autopairs.enable = true;
            autocomplete = {
              enable = true;
              type = "nvim-cmp";
            };
            filetree.nvimTreeLua = {
              enable = true;
            };
            tabline.nvimBufferline.enable = true;
            treesitter = {
              context.enable = true;
            };
            keys = {
              enable = true;
              whichKey.enable = true;
            };
            telescope.enable = true;
            git = {
              enable = true;
              gitsigns.enable = true;
              gitsigns.codeActions = true;
            };
          };
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
