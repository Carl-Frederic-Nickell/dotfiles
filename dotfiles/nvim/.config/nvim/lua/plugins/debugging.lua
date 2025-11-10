return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- DAP UI Setup
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 }
            },
            position = "left",
            size = 40
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 }
            },
            position = "bottom",
            size = 10
          }
        }
      })

      -- Python Debugging (für Security Scripts)
      dap.adapters.python = {
        type = 'executable',
        command = 'python3',
        args = { '-m', 'debugpy.adapter' }
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch Security Script',
          program = '${file}',
          pythonPath = 'python3'
        }
      }

      -- Bash Debugging (für DevOps Scripts)
      dap.adapters.bashdb = {
        type = 'executable',
        command = 'bash-debug-adapter',
        name = 'bashdb'
      }

      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch Bash Script',
          showDebugOutput = true,
          pathBashdb = 'bashdb',
          pathBashdbLib = '/usr/share/bashdb',
          trace = true,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathMappings = {},
          arguments = {},
          terminalKind = 'integrated'
        }
      }

      -- Debugging Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue Debugging" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" }
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  }
}
