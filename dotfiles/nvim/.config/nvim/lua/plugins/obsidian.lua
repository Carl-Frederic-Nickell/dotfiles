return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "CARLs-NoteLab",
        path = "/Users/carl/Documents/12. Obsidian/CARLs NoteLab",
      },
    },
    
    -- Daily Notes Konfiguration (angepasst an deine Struktur)
    daily_notes = {
      folder = "06 - Daily/2025",
      date_format = "%Y%m%d",
      alias_format = "%B %-d, %Y",
      template = "(TEMPLATE) Daily.md"
    },
    
    -- Template Ordner 
    templates = {
      subdir = "99 - Meta",  -- Wo deine Templates liegen
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    
    -- Note ID für DevOps-Projekte (passt zu deinem 03 - Resources Bereich)
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9_-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.date("%Y%m%d")) .. "_" .. suffix
    end,
    
    -- Mappings angepasst an deine Workflow
    mappings = {
      ["<leader>och"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true, desc = "Toggle Checkbox" },
      },
      ["<leader>ont"] = {
        action = ":ObsidianTemplate<CR>",
        opts = { buffer = true, desc = "Insert Template" },
      },
      ["<leader>obl"] = {
        action = ":ObsidianBacklinks<CR>",
        opts = { buffer = true, desc = "Show Backlinks" },
      },
    },
    
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    
    -- Frontmatter für deine IT-Projekte
    note_frontmatter_func = function(note)
      local out = { 
        date = os.date("%Y-%m-%dT%H:%M:%S"),
        tags = note.tags or {},
      }
      
      -- Auto-CSS-Classes basierend auf Bereich
      if note.path and string.find(note.path, "03 %- Resources") then
        if string.find(note.title:lower(), "devops") then
          out.cssclasses = {"pen-green"}
          out.tags = {"IT", "DevOps"}
        elseif string.find(note.title:lower(), "security") then
          out.cssclasses = {"pen-red"}  
          out.tags = {"IT", "Security"}
        else
          out.cssclasses = {"pen-blue"}
          out.tags = {"IT"}
        end
      end
      
      return out
    end,
  },
  
  keys = {
    -- Daily Note (angepasst an deine Struktur)
    { "<leader>odn", ":ObsidianToday<CR>", desc = "Open Daily Note" },
    
    -- IT Template einfügen
    { "<leader>oit", function()
        vim.cmd("ObsidianTemplate template_it_software")
      end, desc = "Insert IT Template" },
    
    -- Quick Search in Resources
    { "<leader>osr", function()
        vim.cmd("ObsidianSearch 03 - Resources")
      end, desc = "Search Resources" },
    
    { "<leader>os", ":ObsidianSearch<CR>", desc = "Search Obsidian" },
    { "<leader>ooa", ":ObsidianOpen<CR>", desc = "Open in Obsidian App" },
  }
}
