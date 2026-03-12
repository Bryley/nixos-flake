return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            -- Better Icons
            vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "Title", linehl = "", numhl = "" })
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = " ", texthl = "DiagnosticFloatingInfo", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapStopped", { text = "󰁙 ", texthl = "", linehl = "TermCursor", numhl = "" })

            local dap = require("dap")
            dap.configurations.rust = {
                {
                    type = "codelldb",
                    request = "launch",
                    name = "Launch file",
                    -- program = "${file}",
                    -- pythonPath = function()
                    --     return "/usr/bin/python"
                    -- end,
                },
            }
        end,
    },
    {
        -- Debugger user interface
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = "go",
        config = function()
            require("dap-go").setup()
        end,
    },
}
