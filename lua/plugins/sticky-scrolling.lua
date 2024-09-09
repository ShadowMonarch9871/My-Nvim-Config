-- Sticky Scrolling
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- Plugin configurations
return {
    -- Existing plugins...

    -- Sticky scrolling
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            require("nvim-navic").setup()
            -- Attach navic to LSP
            local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, bufnr)
                end
            end
            -- Ensure this is called for each LSP setup
        end
    }
}
