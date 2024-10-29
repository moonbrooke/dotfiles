local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set spacebar as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable spacebar default behavior
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- General
map("n", "<C-s>", "<CMD>w<CR>", opts) -- Save file
map("n", "<C-q>", "<CMD>q<CR>", opts) -- Close file or quit if no file's open
map("n", "<leader>sn", "<CMD>noautocmd w<CR>", opts) -- Save without formatting
map("n", "x", '"_x', opts) -- Delete char without copying
map("n", "<leader>=", "ggVG=", opts) -- Format document

-- Buffers
map("n", "<Tab>", "<CMD>bnext<CR>", opts) -- Switch to next buffer
map("n", "<S-Tab>", "<CMD>bprevious<CR>", opts) -- Switch to prev buffer
map("n", "<leader>x", "<CMD>Bdelete!<CR>", opts) -- Close buffer
map("n", "<leader>b", "<CMD>enew<CR>", opts) -- New buffer

-- Window management
map("n", "<leader>h", "<C-w>s", opts) -- Split window horizontally
map("n", "<leader>v", "<C-w>v", opts) -- Split window vertically
map("n", "<leader>se", "<C-w>=", opts) -- Make split windows equal width & height
map("n", "<leader>xs", "<CMD>close<CR>", opts) -- Close current split window

-- Navigate between splits
map("n", "<C-Left>", "<CMD>wincmd h<CR>", opts) -- Navigate left
map("n", "<C-Down>", "<CMD>wincmd j<CR>", opts) -- Navigate Down
map("n", "<C-Up>", "<CMD>wincmd k<CR>", opts) -- Navigate Up
map("n", "<C-Right>", "<CMD>wincmd l<CR>", opts) -- Navigate Right

-- Toggle line wrapping
map("n", "<leader>lw", "<CMD>set wrap!<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yanked when pasting
map("v", "p", '"_dP', opts)

-- Diagnostic keymaps
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic message" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Duplicate
map({ "n" }, "<C-S-A-Up>", "<CMD>LineDuplicate -1<CR>", { desc = "Duplicate line up" })
map({ "n" }, "<C-S-A-Down>", "<CMD>LineDuplicate +1<CR>", { desc = "Duplicate line down" })
map({ "v" }, "<C-S-A-Up>", "<CMD>VisualDuplicate -1<CR>", { desc = "Duplicate selection up" })
map({ "v" }, "<C-S-A-Down>", "<CMD>VisualDuplicate +1<CR>", { desc = "Duplicate selection down" })

-- Visual Multi
vim.g.VM_maps = {
	["Select l"] = "<M-Right>",
	["Select h"] = "<M-Left>",
	["Goto Next"] = "",
	["Goto Prev"] = "",
}
