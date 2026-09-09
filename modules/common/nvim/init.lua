-- Leader
vim.g.mapleader = " "

-- Basic editor behavior
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Keep UI minimal
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

local map = vim.keymap.set

-- Easier window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Helix-like line movement
map({ "n", "v" }, "gh", "^")
map({ "n", "v" }, "gl", "$")

-- Keep selection while indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
