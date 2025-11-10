return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        -- DevOps & Security Parser automatisch installieren
        ensure_installed = {
          -- Basis
          "lua", "vim", "vimdoc", "query",
          -- DevOps Essential
          "yaml", "json", "toml",
          "dockerfile", "bash", "fish",
          -- Infrastructure as Code
          "terraform", "hcl",
          -- Programming für Security Scripts
          "python", "go", "rust",
          -- Web & Configs
          "html", "css", "javascript", "typescript",
          "nginx", "apache",
          -- Documentation
          "markdown", "rst",
          -- Cloud & Kubernetes
          "jsonnet",
        },
        
        auto_install = true,
        
        highlight = { 
          enable = true,
          -- Zusätzliche Highlights für Config-Dateien
          additional_vim_regex_highlighting = { "markdown" }
        },
        
        indent = { 
          enable = true,
          -- Bessere Indentation für YAML/Docker
          disable = { "yaml" }  -- YAML hat eigene Indent-Logic
        },
        
        -- Textobjects für effizientere Navigation
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- DevOps-spezifische Textobjects
              ["af"] = "@function.outer",
              ["if"] = "@function.inner", 
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",      -- Docker/YAML Blocks
              ["ib"] = "@block.inner",
              ["ak"] = "@key.outer",        -- YAML Keys
              ["ik"] = "@key.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]b"] = "@block.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer", 
              ["[c"] = "@class.outer",
              ["[b"] = "@block.outer",
            },
          },
        },
        
        -- Incremental Selection für große Config-Dateien
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<M-space>",
          },
        },
      })
    end
  },
  
  -- Zusätzliche Treesitter-Extensions
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        -- Zeige Kontext für verschachtelte YAML/JSON
        patterns = {
          default = {
            'class',
            'function', 
            'method',
            'block',
            'object',
            'key_value_pair'  -- Für YAML/JSON
          },
        },
      })
    end
  }
}
