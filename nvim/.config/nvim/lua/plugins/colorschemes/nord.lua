return {
	"shaunsingh/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("lualine").setup({
			options = {
				-- ... your lualine config
				theme = "nord",
				-- ... your lualine config
			},
		})
	end,
}
