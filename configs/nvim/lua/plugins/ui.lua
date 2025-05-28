return {
    {
        -- Better UI for neovim lua functions like vim.ui.input()
        "stevearc/dressing.nvim",
        config = true,
    },
    -- {
    --     -- File tree plugin
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    --         "MunifTanjim/nui.nvim",
    --         -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    --         {
    --             "s1n7ax/nvim-window-picker",
    --             opts = {
    --                 selection_chars = "ABCDEFGHIJKLMNOP",
    --                 filter_rules = {
    --                     -- filter using buffer options
    --                     bo = {
    --                         -- if the file type is one of following, the window will be ignored
    --                         filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --                         -- if the buffer type is one of following, the window will be ignored
    --                         buftype = { "terminal", "quickfix" },
    --                     },
    --                 },
    --             },
    --         },
    --     },
    --     keys = {
    --         { "<F2>", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    --     },
    --     opts = {
    --         close_if_last_window = true,
    --         window = {
    --             mappings = {
    --                 ["<space>"] = function() end,
    --                 ["<cr>"] = "open_with_window_picker",
    --                 ["o"] = "open_with_window_picker",
    --                 ["S"] = "split_with_window_picker",
    --                 ["s"] = "vsplit_with_window_picker",
    --             },
    --         },
    --     },
    -- },
    {
        -- Uses "yazi" file manager within neovim
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = {
            "folke/snacks.nvim",
        },
        keys = {
            {
                "<leader>-",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Yazi file manager on file",
            },
            {
                "<leader>=",
                "<cmd>Yazi cwd<cr>",
                desc = "Yazi file manager on project",
            },
        },
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        },
    },
    {
        -- Integration between harpoon and bufferline
        "BourbonBidet/Barpoon",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            },

            -- NOTE: Pick one
            { "akinsho/bufferline.nvim" },
        },
        opts = {
            key_labels = "1234",
        }, -- Config here
    },
    {
        -- Shows buffers at the top of the screen
        "akinsho/bufferline.nvim",
        lazy = false,
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        -- keys = {
        --     { "<A-h>", "<cmd>bprev<cr>",  mode = "n", desc = "Prev Buffer" },
        --     { "<A-l>", "<cmd>bnext<cr>",  mode = "n", desc = "Next Buffer" },
        --     { "<A-c>", "<cmd>BufDel<cr>", mode = "n", desc = "Close Buffer" },
        --     { "<A-h>", "<cmd>bprev<cr>",  mode = "i", desc = "Prev Buffer" },
        --     { "<A-l>", "<cmd>bnext<cr>",  mode = "i", desc = "Next Buffer" },
        --     { "<A-c>", "<cmd>BufDel<cr>", mode = "i", desc = "Close Buffer" },
        -- },
        opts = {
            options = {
                close_command = "BufDel! %d",
                right_mouse_command = "",
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                },
                diagnostics = "nvim_lsp",
                separator_style = "slant",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { "close" },
                },
                -- Doesn't work, todo fix it
                -- custom_filter = function(buf_number)
                --     -- Example logic to only show buffers of the current tabpage
                --     return vim.fn.tabpagenr() == vim.fn.bufwinnr(buf_number)
                -- end,
            },
        },
    },
    {
        -- Statusline plugin
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "SmiteshP/nvim-navic",
            "SmiteshP/nvim-navbuddy",
        },
        config = function()
            local navic = require("nvim-navic")

            require("lualine").setup({
                options = {
                    component_separators = "|",
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_c = { { "filename", path = 1 } },
                },
                inactive_sections = {
                    lualine_c = { { "filename", path = 1 } },
                },
                winbar = {
                    lualine_c = {
                        {
                            function()
                                return navic.get_location()
                            end,
                            cond = function()
                                return navic.is_available()
                            end,
                        },
                    },
                },
            })
        end,
    },
    {
        -- Database Client in Neovim
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup( --[[optional config]])
        end,
    },
    {
        -- Adds terminal window easily
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        },
        config = true,
    },
    {
        -- Startup Page configuration
        "goolord/alpha-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                     ]],
                [[       ████ ██████           █████      ██                     ]],
                [[      ███████████             █████                             ]],
                [[      █████████ ███████████████████ ███   ███████████   ]],
                [[     █████████  ███    █████████████ █████ ██████████████   ]],
                [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                [[  ███████████ ███    ███ █████████ █████ █████ ████ █████   ]],
                [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
                [[                                                                       ]],
                [[                                                                       ]],
                [[                                                                       ]],
            }
            dashboard.section.header.opts = {
                hl = "Function",
                position = "center",
            }

            dashboard.section.buttons.val = {
                dashboard.button("<F1>", "Last Session"),
                dashboard.button("SPC =", "Open File Explorer"),
                dashboard.button("e", "New file", "<cmd>ene <CR>"),
                dashboard.button("SPC f f", "Find file"),
                dashboard.button("SPC f g", "Grep search"),
            }
            _Gopts = {
                position = "center",
                hl = "Type",
                -- wrap = "overflow";
            }

            local function footer()
                local quotes = {
                    "Programming is an art of patience not talent",
                    "Don't comment bad code, rewrite it - Brian Kernighan",
                    "Bad programmers worry about the code. Good programmers worry about data structures and their relationships - Linus Torvalds",
                    "Any fool can write code that a computer can understand. Good programmers write code that humans can understand - Martin Fowler",
                    "One of my most productive days was throwing away 1000 lines of code - Ken Thompson",
                }
                return quotes[math.random(#quotes)]
            end

            dashboard.section.footer.val = footer()

            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end,
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    -- {
    --     -- Advanced Color highlighter and picker
    --     "uga-rosa/ccc.nvim",
    --     lazy = false,
    --     config = function()
    --         vim.opt.termguicolors = true
    --
    --         local ccc = require("ccc")
    --
    --         ccc.setup({
    --             -- Your preferred settings
    --             -- Example: enable highlighter
    --             highlighter = {
    --                 auto_enable = true,
    --                 lsp = true,
    --             },
    --             inputs = {
    --                 ccc.input.rgb,
    --                 ccc.input.hsl,
    --                 ccc.input.oklch,
    --             },
    --             outputs = {
    --                 ccc.output.hex,
    --                 ccc.output.hex_short,
    --                 ccc.output.css_rgb,
    --                 ccc.output.css_hsl,
    --                 ccc.output.css_oklch,
    --             },
    --             convert = {
    --                 { ccc.picker.hex, ccc.output.css_rgb },
    --                 { ccc.picker.css_rgb, ccc.output.css_oklch },
    --                 { ccc.picker.css_oklch, ccc.output.hex },
    --             }
    --         })
    --     end,
    -- },
    {
        -- Simple LLM program
        "Kurama622/llm.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
        config = function()
            local tools = require("llm.common.tools")
            require("llm").setup({
                url = "http://localhost:11434/api/chat",
                model = "deepseek-coder-v2:latest",
                api_type = "ollama",
                style = "right",
                keys = {
                    ["Input:Submit"] = { mode = "n", key = "<cr>" },
                    ["Output:Ask"] = { mode = "n", key = "i" },
                },
                fetch_key = function()
                    return "NONE"
                end,
                app_handler = {
                    OptimizeCode = {
                        handler = tools.side_by_side_handler,
                    },
                },
            })
        end,
    },
}
