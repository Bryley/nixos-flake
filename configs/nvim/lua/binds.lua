local opts = { noremap = true, silent = false }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap("n", "<F3>", "<cmd>noh<cr>", opts) -- Disables highlighting with F3

keymap("i", "<C-H>", "<C-W>", opts) -- Control backspace deletes a word

keymap("t", "<Esc>", "<C-\\><C-n>", opts) -- Esc goes to normal mode in term

-- Stay in visual mode when in doing various tasks
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("v", "y", "ygv", opts)

-- Resize Windows with arrowkeys
keymap("n", "<Left>", "<cmd>vertical resize +1<cr>", opts)
keymap("n", "<Right>", "<cmd>vertical resize -1<cr>", opts)
keymap("n", "<Up>", "<cmd>resize +1<cr>", opts)
keymap("n", "<Down>", "<cmd>resize -1<cr>", opts)

keymap("n", "<S-Left>", "<cmd>vertical resize +5<cr>", opts)
keymap("n", "<S-Right>", "<cmd>vertical resize -5<cr>", opts)
keymap("n", "<S-Up>", "<cmd>resize +5<cr>", opts)
keymap("n", "<S-Down>", "<cmd>resize -5<cr>", opts)

-- Tabs Keybinds
keymap("n", "<A-H>", "<cmd>tabprevious<cr>", opts)
keymap("n", "<A-L>", "<cmd>tabnext<cr>", opts)
keymap("n", "<A-N>", "<cmd>tabnew<cr>", opts)
keymap("n", "<A-C>", "<cmd>tabclose<cr>", opts)

-- Toggle fold using enter key
vim.keymap.set("n", "<CR>", "za", {
    noremap = true,
    silent = true,
    desc = "Toggle fold at cursor",
})

-- Close the window and current buffer
vim.api.nvim_create_user_command("Q", 'execute "BufDel" | close', {})

-- Write the file first, then close the window and current buffer
vim.api.nvim_create_user_command("WQ", 'write | execute "BufDel" | close', {})

keymap("n", "<F1>", "<cmd>LoadLastSession<cr>", opts)

-- Extra command for getting session managing to work with harpoon
vim.api.nvim_create_user_command("LoadLastSession", function()
    require("session_manager").load_current_dir_session()
    require("harpoon").setup({})
end, {})

-- Git diff
vim.api.nvim_create_user_command("Gitdiff", function()
    local line = vim.fn.line(".")

    vim.cmd("split")

    local height = vim.api.nvim_win_get_height(0)
    local target = math.max(line - math.floor(height / 2), 1)

    vim.cmd("terminal git diff HEAD -- %")

    vim.fn.chansend(vim.b.terminal_job_id, tostring(target) .. 'G')
    vim.cmd("startinsert")
end, {})
