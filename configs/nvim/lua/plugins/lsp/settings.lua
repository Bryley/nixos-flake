local M = {}

M.settings = function()
    return {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                    "before",
                    "after",
                    "assert",
                    "spy",
                    "mock",
                    "stub",
                    "pending",
                    "teardown",
                    "setup",
                    "lazy_setup",
                    "lazy_teardown",
                },
            },
        },
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> {  }",
            },
            formatting = {
                command = { "nixfmt" },
            },
            options = {
                nixos = {
                    expr = '(builtins.getFlake "/home/bryley/nixos-flake").nixosConfigurations.laptop.options',
                },
                home_manager = {
                    expr = '(builtins.getFlake "/home/bryley/nixos-flake").homeConfigurations.laptop.options',
                },
            },
        },
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
            },
            check = {
                command = "clippy",
            },
            files = {
                excludeDirs = {
                    ".dart_tool",
                    ".direnv",
                    ".flatpak-builder",
                    ".git",
                    ".gitlab",
                    ".gitlab-ci",
                    ".gradle",
                    ".idea",
                    ".next",
                    ".project",
                    ".scannerwork",
                    ".settings",
                    ".venv",
                    "_build",
                    "archetype-resources",
                    "bin",
                    "frontend/node_modules",
                    "hooks",
                    "node_modules",
                    "po",
                    "screenshots",
                    "target",
                },
                watcherExclude = {
                    ["**/.classpath"] = true,
                    ["**/.dart_tool"] = true,
                    ["**/.direnv"] = true,
                    ["**/.factorypath"] = true,
                    ["**/.flatpak-builder"] = true,
                    ["**/.git/objects/**"] = true,
                    ["**/.git/subtree-cache/**"] = true,
                    ["**/.idea"] = true,
                    ["**/.project"] = true,
                    ["**/.scannerwork"] = true,
                    ["**/.settings"] = true,
                    ["**/.venv"] = true,
                    ["**/_build"] = true,
                    ["**/node_modules"] = true,
                },
            },
        },
        json = {
            schemas = require("schemastore").json.schemas({
                extra = {},
            }),
            validate = { enable = true },
        },
        yaml = {
            schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
            },
            validate = { enable = true },
        },
        ["helm-ls"] = {
            yamlls = {
                path = "yaml-language-server",
            },
        },
        tailwindCSS = {
            includeLanguages = {
                elm = "html",
                rust = "html",
                html = "html",
            },
            classAttributes = { "class", "className", "classList", "ngClass" },
            experimental = {
                -- Include regex for ELM
                classRegex = {
                    -- For Rust
                    'class: "(.*)"',
                    -- For ELM:
                    -- TODO try and get multiline strings working
                    '\\bclass[\\s(<|]+"([^"]*)"',
                    '\\bclass[\\s(]+"[^"]*"[\\s+]+"([^"]*)"',
                    '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                    '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                    '\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
                    '\\bclassList[\\s\\[\\(]+"([^"]*)"',
                    '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
                    '\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
                },
                configFile = 'src/tailwind.css',
            },
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
            },
            validate = true,
        },
        basedpyright = {
            analysis = {
                -- Enable auto-import suggestions
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
            },
            -- If needed, add extra paths (adjust the Python version as appropriate)
            -- extraPaths = { ".venv/lib/python3.11/site-packages" },
        },
    }
end

M.filetypes = {
    tailwindcss = { "html", "elm", "jsx", "tsx", "rust" },
    htmx = { "html", "htmldjango" },
}

M.init_options = {
    tailwindcss = {
        userLanguages = {
            elm = "html",
            rust = "html",
            html = "html",
        },
    },
}

M.cmds = {
    qmlls = {
        "qmlls",
        "-E",
    }
}

return M
