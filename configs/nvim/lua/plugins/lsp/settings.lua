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
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
            },
            check = {
                command = "clippy",
            },
            files = {
                excludeDirs = {
                    "_build",
                    ".dart_tool",
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
                    "archetype-resources",
                    "bin",
                    "hooks",
                    "node_modules",
                    "frontend/node_modules",
                    "po",
                    "screenshots",
                    "target",
                },
                watcherExclude = {
                    ["**/_build"] = true,
                    ["**/.classpath"] = true,
                    ["**/.dart_tool"] = true,
                    ["**/.factorypath"] = true,
                    ["**/.flatpak-builder"] = true,
                    ["**/.git/objects/**"] = true,
                    ["**/.git/subtree-cache/**"] = true,
                    ["**/.idea"] = true,
                    ["**/.project"] = true,
                    ["**/.scannerwork"] = true,
                    ["**/.settings"] = true,
                    ["**/.venv"] = true,
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
                html = "html",
            },
            classAttributes = { "class", "className", "classList", "ngClass" },
            experimental = {
                -- Include regex for ELM
                classRegex = {
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
    }
end

M.filetypes = {
    tailwindcss = { "html", "elm", "jsx", "tsx" },
    htmx = { "html", "htmldjango" },
}

M.init_options = {
    tailwindcss = {
        userLanguages = {
            elm = "html",
            html = "html",
        },
    },
}

return M
