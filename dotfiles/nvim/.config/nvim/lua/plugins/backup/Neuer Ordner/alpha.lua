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

    -- Neue Datei (immer als erster Punkt)
    startify.section.top_buttons.val = {
      startify.button("1", "  Neue Datei", ":ene <BAR> startinsert <CR>"),
    }

    -- MRU (Most Recently Used Files) mit 8 Dateien (Buttons 2-9)
    startify.section.mru.val = { { type = "text", val = "  Zuletzt verwendet", opts = { hl = "SpecialComment", position = "center" } } }
    startify.section.mru.val = vim.list_extend(startify.section.mru.val, startify.mru(8, vim.fn.getcwd()))

    -- Productivity Hub (eigene Sektion)
    startify.section.bottom_buttons.val = {
      { type = "text", val = "󱉟  Productivity Hub", opts = { hl = "SpecialComment", position = "center" } },
      startify.button("p", "  Projekte durchsuchen", ":Telescope projects<CR>"),
      startify.button("s", "  Session laden", ":Telescope persisted<CR>"),
      startify.button("u", "  Plugins updaten", ":Lazy sync<CR>"),
      startify.button("c", "  Neovim Config", ":e $MYVIMRC | :cd %:p:h <CR>"),
      startify.button("q", "  Beenden", ":qa<CR>"),
    }

    -- Setup
    alpha.setup(startify.config)
  end,
}
