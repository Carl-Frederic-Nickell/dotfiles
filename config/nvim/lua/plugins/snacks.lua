return {
    {
        "folke/snacks.nvim",
        priority = 1000, -- Wird früh geladen
        lazy = false, -- Direkt beim Start laden
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
                { section = "startup" },
            },
        },
    },
}