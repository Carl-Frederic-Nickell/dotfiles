return {
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require('telescope').load_extension('project')
      
      -- Project-spezifische Konfiguration
      require('telescope').setup {
        extensions = {
          project = {
            base_dirs = {
              -- Deine Synology NAS Projekte (falls mounted)
              '/Volumes/volume2/docker',
              -- Lokale DevOps Projekte
              '~/projects',
              '~/Documents/DevOps',
              -- Neovim Config als Projekt
              '~/.config',
            },
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true,
            on_project_selected = function(prompt_bufnr)
              -- Auto-öffne wichtige Dateien
              require('telescope.actions').close(prompt_bufnr)
              local project_path = require('telescope.actions.state').get_selected_entry().value
              vim.cmd('cd ' .. project_path)
              
              -- Suche nach wichtigen Dateien im Projekt
              local files_to_check = {
                'docker-compose.yml',
                'README.md', 
                'main.py',
                'playbook.yml',
                'Dockerfile'
              }
              
              for _, file in ipairs(files_to_check) do
                if vim.fn.filereadable(project_path .. '/' .. file) == 1 then
                  vim.cmd('edit ' .. file)
                  break
                end
              end
            end
          }
        }
      }
    end
  },
  {
    "olimorris/persisted.nvim",
    config = function()
      require("persisted").setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
        silent = false,
        use_git_branch = true,
        autosave = true,
        autoload = false,  -- Dashboard zuerst anzeigen
        should_autosave = false,  -- Verhindert Auto-Save beim VimEnter
        on_autoload_no_session = function()
          vim.notify("No existing session to load.")
        end,
        allowed_dirs = {
          "~/projects",
          "~/Documents/DevOps", 
          "~/.config/nvim",
          "/Volumes/volume2/docker"
        },
        ignored_dirs = {
          "/tmp",
          "~/.cache"
        }
      })
      
      -- Auto-save session nur beim Beenden
      local group = vim.api.nvim_create_augroup("PersistedHooks", {})
      
      -- KEIN VimEnter Autocmd mehr - Dashboard soll zuerst kommen
      
      vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
        group = group,
        callback = function()
          require("persisted").save()
        end,
      })
    end
  },
  
  -- Keymaps für Project Management
  keys = {
    -- Projekt wechseln
    { "<leader>pp", ":Telescope project<CR>", desc = "Switch Project" },
    
    -- Session Management  
    { "<leader>pss", ":SessionSave<CR>", desc = "Save Session" },
    { "<leader>psl", ":SessionLoad<CR>", desc = "Load Session" },
    { "<leader>psd", ":SessionDelete<CR>", desc = "Delete Session" },
    
    -- Quick Project Creation
    { "<leader>pn", function()
        local project_name = vim.fn.input("Project name: ")
        if project_name ~= "" then
          local project_path = "~/projects/" .. project_name
          vim.fn.mkdir(vim.fn.expand(project_path), "p")
          vim.cmd("cd " .. project_path)
          -- Erstelle Standard DevOps-Dateien
          vim.fn.writefile({"# " .. project_name, "", "## Setup", "", "## Usage"}, "README.md")
          vim.fn.writefile({"version: '3.8'", "services:"}, "docker-compose.yml")
          vim.cmd("edit README.md")
        end
      end, desc = "New Project" },
      
    -- Git-Integration für Projekte  
    { "<leader>pg", ":Telescope git_files<CR>", desc = "Git Files" },
    { "<leader>pb", ":Telescope git_branches<CR>", desc = "Git Branches" },
  }
}