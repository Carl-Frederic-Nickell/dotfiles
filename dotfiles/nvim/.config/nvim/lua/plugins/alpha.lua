return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local startify = require("alpha.themes.startify")

    -- HEADER
    startify.section.header.val = {
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
    }

-- Quick Actions (sichere Keybinds)
startify.section.top_buttons.val = {
  startify.button("e", "📁  Neue Datei", ":ene <BAR> startinsert <CR>"),
  startify.button("n", "📝  Daily Note", function()
    -- Fallback falls Obsidian nicht verfügbar
    if pcall(require, "obsidian") then
      vim.cmd("ObsidianToday")
    else
      -- Alternative: Erstelle Daily Note manuell
      local date = os.date("%Y-%m-%d")
      vim.cmd("e ~/Documents/12. Obsidian/CARLs NoteLab/06 - Daily/2025/" .. date .. ".md")
    end
  end),
  startify.button("D", "🐳  Docker Compose", ":e docker-compose.yml<CR>"),
}

-- MRU Files ohne Überschrift
    startify.section.mru.val = {}
    startify.section.mru.val = vim.list_extend(startify.section.mru.val, startify.mru(6, vim.fn.getcwd()))

    -- DevOps Productivity Hub
    startify.section.bottom_buttons.val = {
      { type = "text", val = "DevOps Productivity Hub", opts = { hl = "SpecialComment" } },
      startify.button("p", "📁  Projekte wechseln", ":Telescope project<CR>"),
      startify.button("f", "🔭  Dateien suchen", ":Telescope find_files<CR>"),
      startify.button("g", "🔍  Code durchsuchen", ":Telescope live_grep<CR>"),
      startify.button("s", "💾  Session laden", ":SessionLoad<CR>"),
      startify.button("b", "📖  Obsidian suchen", function()
        if pcall(require, "obsidian") then
          vim.cmd("ObsidianSearch")
        else
          vim.cmd("Telescope find_files cwd=~/Documents/12. Obsidian/CARLs NoteLab/")
        end
      end),
      startify.button("d", "🐛  Debug starten", ":lua require('dap').continue()<CR>"),
      startify.button("m", "🔧  Mason LSP", ":Mason<CR>"),
      startify.button("l", "🔄  Lazy Plugins", ":Lazy<CR>"),
      startify.button("u", "⬆️  Updates", ":Lazy sync<CR>"),
      startify.button("c", "⚙️  Neovim Config", ":e $MYVIMRC | :cd %:p:h <CR>"),
      startify.button("q", "🚪  Beenden", ":qa<CR>"),
    }

    -- Footer
    startify.section.footer.val = {
      { type = "text", val = "Tip: <Leertaste> zeigt alle Shortcuts mit Which-Key", opts = { hl = "Comment", position = "center" } },
    }

    -- Dashboard-Toggle Keymap
    vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Open Dashboard" })

    alpha.setup(startify.config)
  end,
}