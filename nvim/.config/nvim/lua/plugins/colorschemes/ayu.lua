return {
	"Shatur/neovim-ayu",
	lazy = false,
	priority = 1000,
	config = function()
		require("ayu").setup({
			mirage = true,
			terminal = true,
		})
	end,
}
