return {
    {
        -- Parser for many languages that provides better highlighting
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            -- NOTE: additional parser
            { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
        },
        build = ":TSUpdate",
        lazy = false,
        config = function()
            ---@diagnostic disable: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                ignore_install = { "smali" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["ia"] = "@parameter.inner",
                            ["aa"] = "@parameter.outer",
                        },
                    },
                },
            })
        end,
    },
    {
        -- Treesitter for surrealdb SQL
        "dariuscorvus/tree-sitter-surrealdb.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- setup step
            require("tree-sitter-surrealdb").setup()
        end,
    },
}
