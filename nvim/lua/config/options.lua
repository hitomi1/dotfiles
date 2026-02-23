-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.conceallevel = 0
opt.cmdheight = 0

vim.g.root_spec = { "cwd" }
vim.g.omni_sql_no_default_maps = 1
-- Find python3 dynamically across platforms
local python3 = vim.fn.exepath("python3")
if python3 ~= "" then
  vim.g.python3_host_prog = python3
end
