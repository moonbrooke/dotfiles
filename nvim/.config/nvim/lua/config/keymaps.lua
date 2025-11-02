local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable spacebar default behavior
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- General
map("n", "<C-s>", "<CMD>w<CR>", opts) -- Save file
map("n", "<C-q>", "<CMD>q<CR>", opts) -- Close file or quit if no file's open
map("n", "<leader>sn", "<CMD>noautocmd w<CR>", opts) -- Save without formatting
map("n", "x", '"_x', opts) -- Delete char without copying
map("n", "<leader>=", "ggVG=", opts) -- Format document

map('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })

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

-- Duplicate
map({ "n" }, "<C-S-A-Up>", "<CMD>LineDuplicate -1<CR>", { desc = "Duplicate line up" })
map({ "n" }, "<C-S-A-Down>", "<CMD>LineDuplicate +1<CR>", { desc = "Duplicate line down" })
map({ "v" }, "<C-S-A-Up>", "<CMD>VisualDuplicate -1<CR>", { desc = "Duplicate selection up" })
map({ "v" }, "<C-S-A-Down>", "<CMD>VisualDuplicate +1<CR>", { desc = "Duplicate selection down" })

