return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
      }
    })
    
    -- DevOps & Security Keybinding Groups
    wk.register({
      ["<leader>d"] = { name = "🐛 Debug" },
      ["<leader>g"] = { name = "🌿 Git" },
      ["<leader>f"] = { name = "🔍 Find" },
      ["<leader>t"] = { name = "🧪 Test" },
      ["<leader>c"] = { name = "💻 Code" },
      ["<leader>o"] = { name = "📝 Obsidian" },
      ["<leader>p"] = { name = "📁 Project" },
      ["<leader>s"] = { name = "🔒 Security" },
    })
    
    -- Spezifische Debug Keymaps registrieren
    wk.register({
      ["<leader>db"] = { "Toggle Breakpoint" },
      ["<leader>dc"] = { "Continue" },
      ["<leader>ds"] = { "Step Over" },
      ["<leader>di"] = { "Step Into" },
      ["<leader>do"] = { "Step Out" },
      ["<leader>dr"] = { "Open REPL" },
      ["<leader>du"] = { "Toggle Debug UI" },
    })
  end
}
