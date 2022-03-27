vim.opt.fileencodings = "utf-8,cp932,sjis"
vim.opt.lazyredraw = true

require("kdein")

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
vim.opt.laststatus = 3
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

-- use w{h,j,k,l} to switch between windows
vim.api.nvim_set_keymap("n", "wh", "<C-w><Left>", mapopt)
vim.api.nvim_set_keymap("n", "wj", "<C-w><Down>", mapopt)
vim.api.nvim_set_keymap("n", "wk", "<C-w><Up>", mapopt)
vim.api.nvim_set_keymap("n", "wl", "<C-w><Right>", mapopt)

-- use esc-esc to remove search highlight
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

vim.cmd([[
    hi TrailingSpaces gui=underline guifg=#268bd2
    match TrailingSpaces /\s\+$/
]])

-- just trying new API!

if vim.api.nvim_add_user_command == nil then
    error("use HEAD version of neovim!")
    return
end

vim.api.nvim_create_autocmd("StdinReadPost", {
    pattern = {"*"},
    callback = function() vim.opt.modified = false end,
})

vim.api.nvim_create_autocmd("FocusLost", {
    pattern = {"*"},
    command = "silent! wa"
})

vim.api.nvim_create_autocmd("Filetype", {
    pattern = {"go"},
    callback = function() require("kft").on_ft("go") end,
})

local function def_alias(name, cmd)
    vim.api.nvim_add_user_command(name, function() vim.cmd(cmd) end, {})
end

def_alias("W", "w")
def_alias("Wq", "wq")
def_alias("WQ", "wq")
def_alias("Q", "q")

