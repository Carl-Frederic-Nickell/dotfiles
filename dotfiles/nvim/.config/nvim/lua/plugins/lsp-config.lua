return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      -- DevOps & Security LSP Server automatisch installieren
      ensure_installed = {
        "lua_ls",
        "tsserver", 
        "html",
        "yamlls",                   -- YAML/Ansible
        "terraformls",             -- Terraform
        "dockerls",                -- Docker
        "bashls",                  -- Bash Scripts
        "pyright",                 -- Python
        "gopls",                   -- Go
        "ansiblels",               -- Ansible
        "jsonls",                  -- JSON
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")

      -- Bestehende LSP Server
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.solargraph.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })

      -- DevOps & Security LSP Server
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/ansible-stable-2.9"] = "playbooks/*.yml",
              ["https://json.schemastore.org/docker-compose"] = "docker-compose*.yml",
              ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.yml"
            }
          }
        }
      })

      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.ansiblels.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })

      -- LSP Keymaps (bestehend)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}