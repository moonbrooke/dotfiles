# quickstart.nvim

A Neovim config to get started quickly.

### Installation

Requirements:

- [Neovim 0.95+](https://github.com/neovim/neovim/releases/tag/stable)
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

Backup your current nvim folders (if any):

```bash
# Linux/Mac
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# Windows
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Clone the repository:

```bash
# Linux/Mac
git clone https://github.com/moonbrooke/quickstart.nvim.git ~/.config/nvim

# Windows
git clone https://github.com/moonbrooke/quickstart.nvim.git $env:LOCALAPPDATA\nvim
```

(Optional) Remove the .git folder:

```bash
# Linux/Mac
rm -rf ~/.config/nvim/.git

# Windows
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

Start Neovim:

```bash
nvim
```
