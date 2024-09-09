return {
	{
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"lua_ls",
						"clangd",
						"html",
						"cssls",
						"tailwindcss",
						"eslint",
						"jsonls",
						"emmet_ls",
						"pyright",
					},
				})

				-- Add the new setup logic here
				require("mason-lspconfig").setup_handlers({
					function(server_name)
						-- Handle tsserver/ts_ls specifically
						if server_name == "tsserver" then
							server_name = "ts_ls" -- Keep it as tsserver for now
						end

						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- Lua
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})

				-- C/C++
				lspconfig.clangd.setup({
					capabilities = capabilities,
				})

				-- TypeScript/JavaScript
				lspconfig.tsserver.setup({
					capabilities = capabilities,
				})

				-- HTML
				lspconfig.html.setup({
					capabilities = capabilities,
				})

				-- CSS
				lspconfig.cssls.setup({
					capabilities = capabilities,
				})

				-- Tailwind CSS
				lspconfig.tailwindcss.setup({
					capabilities = capabilities,
				})

				-- ESLint
				lspconfig.eslint.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				})

				-- JSON
				lspconfig.jsonls.setup({
					capabilities = capabilities,
				})

				-- Emmet
				lspconfig.emmet_ls.setup({
					capabilities = capabilities,
					filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
				})

				-- Python
				lspconfig.pyright.setup({
					capabilities = capabilities,
				})

				-- Global mappings
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

				-- Use LspAttach autocommand to only map the following keys
				-- after the language server attaches to the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("UserLspConfig", {}),
					callback = function(ev)
						local opts = { buffer = ev.buf }
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
						vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
						vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
						vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
						vim.keymap.set("n", "<space>wl", function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end, opts)
						vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
						vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
						vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
						vim.keymap.set("n", "<space>f", function()
							vim.lsp.buf.format({ async = true })
						end, opts)
					end,
				})
			end,
		},
	},
}
