-- ==========================================
-- 1. BOOTSTRAP LAZY.NVIM
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 2. CORE SETTINGS (From your .vimrc)
-- ==========================================
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ==========================================
-- 3. CONTAINER CLIPBOARD (OSC 52)
-- ==========================================
-- This is critical. It forces yanked text out of the isolated Ubuntu 
-- container and directly into your Mac's host clipboard.
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- ==========================================
-- 4. KEYMAPS
-- ==========================================
local map = vim.keymap.set

-- Escape alias
map('i', 'jk', '<ESC>', { noremap = true })

-- Fast scrolling
map('n', '<C-d>', '10j', { noremap = true })
map('n', '<C-u>', '10k', { noremap = true })
map('n', '<C-e>', '10<C-e>', { noremap = true })
map('n', '<C-y>', '10<C-y>', { noremap = true })

-- Enter creates new line without entering insert mode
map('n', '<Enter>', 'o<ESC>', { noremap = true })
map('n', '<S-Enter>', 'O<ESC>', { noremap = true })

-- ==========================================
-- 5. PLUGINS
-- ==========================================
require("lazy").setup({
  -- Theme
  {
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  },
  
  -- Tmux Navigation (Ports your C-h/j/k/l logic)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },
})
