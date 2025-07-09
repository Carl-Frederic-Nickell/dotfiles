return {
  "tpope/vim-commentary",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        local commentstrings = {
          python = "#",
          lua = "--",
          javascript = "//",
          typescript = "//",
          html = "<!-- %s -->",
          css = "/* %s */",
          bash = "#",
          sh = "#",
          zsh = "#",
          fish = "#",
          conf = "#",
          yaml = "#",
          dockerfile = "#",
          ruby = "#",
          perl = "#",
          php = "//",
          c = "//",
          cpp = "//",
          -- DevOps/Security relevante Formate
          go = "//",
          rust = "//",
          terraform = "#",
          hcl = "#",
          ansible = "#",
          toml = "#",
          json = "// %s",
          sql = "--",
          nginx = "#",
          xml = "<!-- %s -->",
          markdown = "<!-- %s -->"
        }
        
        local ft = vim.bo.filetype
        if commentstrings[ft] then
          vim.bo.commentstring = commentstrings[ft] .. " %s"
        end
      end
    })
  end
}
