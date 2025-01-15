return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    'mfussenegger/nvim-dap',
    config = function ()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dappui_config = function ()
        dapui.open()
      end
      dap.listeners.before.launch.dappui_config = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dappui_config = function ()
        dapui.close()
      end
      dap.listeners.before.event_exied.dappui_config = function ()
        dapui.close()
      end
    end
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function ()
      require("dapui").setup()
    end
  },

  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function ()
      require('crates').setup()
      require("cmp").setup.buffer({
        sources = { { name = "crates" } }
      })
    end,
  },
  -- {
  --	"nvim-treesitter/nvim-treesitter",
  --	opts = {
  --		ensure_installed = {
  --			"vim", "lua", "vimdoc",
  --      "html", "css",
  --      "solidity", "json",
  --      "toml"
  --		},
  --    auto_install = true,
  --    highlight = {
  --      enable = true,
  --    },
  --    incremental_selection = {
  --      enable = true,
  --      keymaps = {
  --        init_selection = "gnn",
  --        node_incremental = "grn",
  --        scope_incremental = "grc",
  --        node_decremental = "grm",
  --      },
  --    },
  --	},
  -- },
}
