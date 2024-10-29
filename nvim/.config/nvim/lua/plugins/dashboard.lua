return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			-- config
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						icon = "󰈞 ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = " Commands",
						-- group = "DashboardShortCutIcon",
						action = "Telescope commands",
						key = "c",
					},
					{ desc = "󰏔 Sync", group = "@property", action = "Lazy sync", key = "s" },
					{
						desc = "󰏓 Mason",
						group = "Number",
						action = "Mason",
						key = "m",
					},
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
