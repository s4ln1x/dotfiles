-- Plugin management with lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "vim-airline/vim-airline",
  "morhetz/gruvbox",
  "airblade/vim-gitgutter",
})

-- Vim airline
vim.g.airline_powerline_fonts = 1

-- Default Values
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.cmd("syntax enable")
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Set color column to 80
vim.opt_local.colorcolumn = "80"

-- Gruvbox config
vim.opt.termguicolors = true
vim.g.gruvbox_guisp_fallback = "bg"
vim.cmd("colorscheme gruvbox")
vim.opt.background = "light"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true

-- File handling
vim.opt.autoread = true

-- Tabs and spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Trailing spaces
vim.cmd([[
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
]])

-- Encoding and filetype
vim.opt.encoding = "utf-8"
vim.cmd("filetype on")

-- Clipboard
vim.opt.clipboard:append({"unnamed", "unnamedplus"})

-- Font for GUI
if vim.g.neovide or vim.g.fvim then
  vim.opt.guifont = "JetBrains Mono:h10"
end

-- Remove trailing whitespace
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "s/\\s\\+$//e",
})
