-- vim.cmd("language en_US")

vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local o = vim.opt

o.termguicolors = true

o.number = true
-- o.relativenumber = true

o.mouse = "a"
o.showmode = false

vim.schedule(function()
	o.clipboard = "unnamedplus"
end)

o.fileencoding = "utf-8"
o.title = true
o.swapfile = false
o.backup = false
o.writebackup = false
o.undofile = true
o.backspace = "indent,eol,start"

o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"

o.updatetime = 250
o.timeoutlen = 300

o.splitright = true
o.splitbelow = true

o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.inccommand = "split"
o.cursorline = true
o.scrolloff = 10
o.pumheight = 10
o.completeopt = "menuone,noselect"

o.autoindent = true
o.breakindent = true
o.wrap = false
o.linebreak = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.scrolloff = 4
o.sidescrolloff = 8
-- o.showtabline = 2
