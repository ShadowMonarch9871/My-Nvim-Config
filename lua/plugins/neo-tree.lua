return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = false,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            window = {
                width = 30,
                mappings = {
                    ["<cr>"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
                use_libuv_file_watcher = true,
            },
        })

        -- Toggle Neotree
        vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })
        
        -- Resize Neotree
        vim.keymap.set('n', '<leader>n[', ':vertical resize -5<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>n]', ':vertical resize +5<CR>', { noremap = true, silent = true })   

        -- Disable line numbers in Neotree
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neo-tree",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
            end,
        })
    end
}
