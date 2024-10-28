return {
	"echasnovski/mini.move",
	version = "*",
	config = function()
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				-- left = "<M-left>",
				-- right = "<M-right>",
				down = "<M-down>",
				up = "<M-up>",

				-- Move current line in Normal mode
				-- line_left = "<M-left>",
				-- line_right = "<M-right>",
				line_down = "<M-down>",
				line_up = "<M-up>",
			},

			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		})
	end,
}
