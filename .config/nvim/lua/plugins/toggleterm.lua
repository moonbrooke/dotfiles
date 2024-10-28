return {
	"akinsho/toggleterm.nvim",
	keys = {
		{ "<C-\\>", "<CMD>ToggleTerm<CR>", desc = "Toggle Terminal", mode = "n" },
		{ "<C-\\>", "<CMD>ToggleTerm<CR>", desc = "Toggle Terminal", mode = "t" },
	},
	opts = {
		shade_terminals = true,
		direction = "horizontal",
		size = 15,
	},
}
