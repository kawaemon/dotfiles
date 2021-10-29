vim.opt.fileencodings = "utf-8,cp932,sjis"
vim.opt.lazyredraw = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.title = true

vim.opt.clipboard = "unnamedplus"
vim.opt.showmatch = true

vim.opt.matchtime = 2
vim.opt.pumheight = 20


-- disable arrow keys and help key.
local disallowedKeys = {"<Up>", "<Down>", "<Left>", "<Right>", "<F1>"}
for i, v in ipairs(disallowedKeys) do
    vim.api.nvim_set_keymap("n", v, "<Nop>", { noremap = true })
    vim.api.nvim_set_keymap("i", v, "<Nop>", { noremap = true })
end

-- use Y to yank cursor from end of line
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

-- buffer keymaps
vim.api.nvim_set_keymap("n", "sh", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "sl", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "sd", ":bdelete<CR>", { noremap = true, silent = true })

-- use w{h,j,k,l} to switch between panels
vim.api.nvim_set_keymap("n", "wh", "<C-w>w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "wj", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "wk", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "wl", "<C-w>l", { noremap = true, silent = true })

-- use esc-esc for remove search highlight
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })


local vimrcDir = vim.env.HOME .. "/.config/nvim"
local deinDir = vimrcDir .. "/dein"
local deinRepoDir = deinDir .. "/repos/github.com/Shougo/dein.vim"

if vim.fn["isdirectory"](deinDir) == 0 then
    vim.fn["system"]("git clone https://github.com/Shougo/dein.vim " .. vim.fn["shellescape"](deinRepoDir))
end

vim.o.runtimepath = deinRepoDir .. "," .. vim.o.runtimepath

if vim.fn["dein#load_state"](deinDir) ~= 0 then
    local minimumPlugins = vimrcDir .. "/minimum_plugins.toml"
    local plugins        = vimrcDir .. "/plugins.toml"
    local lazyPlugins    = vimrcDir .. "/lazy_plugins.toml"

    local load_toml = vim.fn["dein#load_toml"]

    vim.fn["dein#begin"](deinDir)
    load_toml(minimumPlugins, { lazy = 0 })
    load_toml(plugins, { lazy = 0 })
    load_toml(lazyPlugins, { lazy = 1 })
    vim.fn["dein#end"]()
    vim.fn["dein#save_state"]()
end

if vim.fn["dein#check_install"]() ~= 0 then
    vim.fn["dein#install"]()
end
