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
vim.opt.signcolumn = "number"
vim.opt.wrap = false
vim.opt.title = true
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"
vim.opt.showmatch = true
vim.opt.matchpairs:append({ "<:>" })
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"

vim.opt.matchtime = 2
vim.opt.pumheight = 20

local mapopt = { noremap = true, silent = true }

-- disable arrow keys, help key, macro key, ex-mode key.
local disallowedKeys = { "<Up>", "<Down>", "<Left>", "<Right>", "<F1>" }
for i, v in ipairs(disallowedKeys) do
    vim.api.nvim_set_keymap("n", v, "<Nop>", mapopt)
    vim.api.nvim_set_keymap("i", v, "<Nop>", mapopt)
end

disallowedKeys = { "q", "Q" }
for i, v in ipairs(disallowedKeys) do
    vim.api.nvim_set_keymap("n", v, "<Nop>", mapopt)
end

-- use Y to yank from cursor to end of line
vim.api.nvim_set_keymap("n", "Y", "y$", mapopt)

-- buffer keymaps
vim.api.nvim_set_keymap("n", "sh", ":bp<CR>", mapopt)
vim.api.nvim_set_keymap("n", "sl", ":bn<CR>", mapopt)
vim.api.nvim_set_keymap("n", "sd", ":b#|bw#|bp|bn<CR>", mapopt)

-- use w{h,j,k,l} to switch between panels
vim.api.nvim_set_keymap("n", "wh", "<C-w>w", mapopt)
vim.api.nvim_set_keymap("n", "wj", "<C-w>j", mapopt)
vim.api.nvim_set_keymap("n", "wk", "<C-w>k", mapopt)
vim.api.nvim_set_keymap("n", "wl", "<C-w>l", mapopt)

-- use esc-esc to remove search highlight
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

local vimrcDir    = vim.env.HOME .. "/.config/nvim"
local deinDir     = vimrcDir     .. "/dein"
local deinRepoDir = deinDir      .. "/repos/github.com/Shougo/dein.vim"

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

vim.cmd([[
    hi TrailingSpaces gui=underline guifg=#268bd2
    match TrailingSpaces /\s\+$/

    autocmd FocusLost * silent! wa
    autocmd InsertLeave * silent! w
    autocmd Filetype go lua require("kft").on_ft("go")
]])

-- just trying new API!

if vim.api.nvim_add_user_command == nil then
    error("use HEAD version of neovim!")
    return
end

local function def_alias(name, cmd)
    vim.api.nvim_add_user_command(name, function() vim.cmd(cmd) end, {})
end

def_alias("W", "w")
def_alias("Wq", "wq")
def_alias("WQ", "wq")

