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
