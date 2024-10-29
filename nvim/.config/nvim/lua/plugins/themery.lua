return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			-- add the config here
			themes = {
				"ayu",
				"catppuccin",
				"eldritch",
				"gruvbox",
				"kanagawa",
				"nightfox",
				"nord",
				"nordic",
				"rose-pine",
				"tokyonight",
			},
			livePreview = true,
		})
	end,
}
