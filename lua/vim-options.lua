-- Use vim.opt instead of vim.cmd for better readability and consistency
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.indentexpr = "nvim_treesitter#indent()"
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.scrolloff = 10
vim.opt.wrap=true
vim.opt.mouse=""


-- Function to set line numbers
local function set_line_numbers()
    if vim.bo.filetype ~= "neo-tree" then
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    else
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
end

-- Set line numbers for new buffers
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    callback = set_line_numbers,
})

-- Apply line number settings to existing buffers
set_line_numbers()

-- Window navigation keymaps
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- Replace all instances of a word
vim.api.nvim_set_keymap("n", "<leader>ra", ":%s/<C-r><C-w>//g<Left><Left>", { noremap = true })
-- Replace one instance of a word
vim.api.nvim_set_keymap("n", "<leader>ro", ":s/<C-r><C-w>//g<Left><Left>", { noremap = true })
-- Replace instances of a word with visual selection
vim.api.nvim_set_keymap("v", "<leader>rs", ":s///g<Left><Left><Left>", { noremap = true })

-- Optional: Add a command to toggle line numbers
vim.api.nvim_create_user_command("ToggleLineNumbers", function()
    if vim.bo.filetype ~= "neo-tree" then
        vim.opt_local.number = not vim.opt_local.number:get()
        vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get()
    end
end, {})

-- Optional: Map the toggle command to a key
vim.keymap.set("n", "<leader>tn", ":ToggleLineNumbers<CR>", { noremap = true, silent = true })
