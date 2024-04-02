-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)

keymap("n", "<leader>td", ":ToggleTerm size=40 direction=vertical <CR>", opts)
