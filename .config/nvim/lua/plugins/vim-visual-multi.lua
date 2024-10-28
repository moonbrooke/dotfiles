return {
	"mg979/vim-visual-multi",
	branch = "master",
	config = function()
		-- By default, Ctrl+n will behave like Ctrl+D in VS Code
		-- vim.g.VM_default_mappings = 0 -- Disable default mappings (optional)
		-- vim.api.nvim_set_keymap("n", "<C-d>", "<Plug>(VM-Find-Under)", {})
		-- vim.api.nvim_set_keymap("v", "<C-d>", "<Plug>(VM-Find-Subword-Under)", {})
	end,
}
