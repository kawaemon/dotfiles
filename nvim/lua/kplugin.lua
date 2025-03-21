local uv = vim.loop

local unnamed_path = vim.env.HOME .. "/.config/nvim/unnamed"
local stat, err = uv.fs_stat(unnamed_path)
if stat == nil then
    vim.notify("installing unnamed")
    vim.fn.system("git clone https://github.com/approvers/unnamed.git " .. unnamed_path)
end

vim.opt.runtimepath:prepend(unnamed_path)

local plugins = {
    {
        repo = "ishan9299/nvim-solarized-lua",
        fast_setup = function()
            vim.cmd("colorscheme solarized-flat")
            vim.cmd("hi! link @variable normal")
        end,
    },
    {
        repo = "j-hui/fidget.nvim",
        setup = function()
            require("fidget").setup({
                notification = {
                    override_vim_notify = true,
                    view = { stack_upwards = false },
                    window = { winblend = 0 },
                },
            })
        end
    },
    {
        repo = "Darazaki/indent-o-matic",
        fast_setup = function()
            require('indent-o-matic').setup({})
        end
    },
    {
        repo = "nvim-lualine/lualine.nvim",
        fast_setup = function()
            local theme = require("lualine.themes.solarized_dark")

            local base02 = theme.normal.c.bg
            local base0 = theme.inactive.a.fg

            theme.normal.a.fg = base0
            theme.insert.a.fg = theme.insert.a.bg
            theme.visual.a.fg = theme.visual.a.bg
            theme.replace.a.fg = theme.replace.a.bg

            theme.normal.a.bg = base02
            theme.insert.a.bg = base02
            theme.visual.a.bg = base02
            theme.replace.a.bg = base02

            theme.normal.a.gui = ''
            theme.insert.a.gui = ''
            theme.visual.a.gui = ''
            theme.replace.a.gui = ''

            require("lualine").setup({
                options = {
                    theme = theme,
                    icons_enabled = false,
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = {{ "mode", fmt = string.lower }},
                    lualine_b = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {
                    lualine_a = {
                        {
                            "buffers",
                            max_length = function()
                                return vim.o.columns
                            end,
                        },
                    },
                },
            })
        end,
    },
    {
        repo = "kdheepak/lazygit.nvim",
        setup = function()
            vim.api.nvim_create_user_command("Lg", function()
                vim.cmd(":LazyGit")
            end, {})
        end,
    },
    {
        repo = "lewis6991/gitsigns.nvim",
        setup = function()
            require("gitsigns").setup({
                signs = { delete = { text = "┃" } },
            })
            vim.api.nvim_create_user_command("Blame", function()
                vim.cmd("Gitsigns toggle_current_line_blame")
            end, {})
        end,
    },

    "kyazdani42/nvim-web-devicons",
    {
        repo = "kyazdani42/nvim-tree.lua",
        fast_setup = function()
            vim.api.nvim_create_user_command("Tree", function()
                vim.cmd(":NvimTreeToggle")
            end, {})

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function(data)
                    local has_name = data.file ~= "" or vim.bo[data.buf].buftype ~= ""
                    if has_name then
                        return
                    end

                    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
                end,
            })

            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    local tree_wins = {}
                    local floating_wins = {}
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do
                        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                        if bufname:match("NvimTree_") ~= nil then
                            table.insert(tree_wins, w)
                        end
                        if vim.api.nvim_win_get_config(w).relative ~= "" then
                            table.insert(floating_wins, w)
                        end
                    end
                    if 1 == #wins - #floating_wins - #tree_wins then
                        for _, w in ipairs(tree_wins) do
                            vim.api.nvim_win_close(w, true)
                        end
                    end
                end,
            })

            vim.cmd("highlight NvimTreeIndentMarker guifg=#46595e gui=nocombine")

            require("nvim-tree").setup({
                git = { ignore = false },
                update_focused_file = { enable = true, },
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                    icons = {
                        hint = "H",
                        info = "I",
                        warning = "W",
                        error = "E",
                    },
                },
                renderer = {
                    highlight_diagnostics = true,
                    special_files = {},
                    indent_width = 1,
                    indent_markers = {
                        enable = true,
                        inline_arrows = false,
                        icons = {
                          corner = "│",
                          edge = "│",
                          item = "│",
                          bottom = "",
                          none = " ",
                        }
                    },
                    icons = {
                        git_placement = "signcolumn",
                        show = {
                            git = true,
                            file = true,
                            folder = true,
                            folder_arrow = true,
                        },
                        glyphs = {
                            git = {
                                unstaged = "",
                                staged = "",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "󰐕",
                                deleted = "",
                                ignored = "",
                            },
                        },
                    },
                },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end
                    local mappings = {
                        ["<CR>"] = { api.node.open.edit, "Open" },
                        ["a"] = { api.fs.create, "Create" },
                        ["d"] = { api.fs.remove, "Delete" },
                        ["p"] = { api.fs.paste, "Paste" },
                        ["r"] = { api.fs.rename, "Rename" },
                        ["x"] = { api.fs.cut, "Cut" },
                        ["y"] = { api.fs.copy.node, "Copy" },
                        ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
                    }
                    for keys, mapping in pairs(mappings) do
                        vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
                    end
                end,
            })
        end,
    },
    {
        repo = "lukas-reineke/indent-blankline.nvim",
        setup = function()
            require("ibl").setup({ scope = { enabled = false } })
        end,
    },
    {
        repo = "easymotion/vim-easymotion",
        setup = function()
            vim.api.nvim_set_keymap("n", "ss", "<Plug>(easymotion-s2)", {})
        end,
    },
    {
        repo = "junegunn/fzf.vim",
        setup = function()
            vim.api.nvim_create_user_command("F", function()
                vim.cmd("Files")
            end, {})
        end,
    },

    -- #### tree-sitter ####
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/playground",
    {
        repo = "nvim-treesitter/nvim-treesitter",
        setup = function()
            local parser_path = "~/.cache/nvim/tree-sitter-parsers"
            vim.opt.runtimepath:prepend(parser_path)
            require("nvim-treesitter.configs").setup({
                parser_install_dir = parser_path,
                ensure_installed = "all",
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
                playground = { enable = true },
            })

            vim.cmd([[
                hi! clear TSError
                hi TSError gui=underline guifg=#dc322f
            ]])
        end,
    },

    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",

    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        repo = "folke/trouble.nvim",
        setup = function()
            require("trouble").setup()
        end,
    },

    {
        repo = "hrsh7th/nvim-cmp",
        setup = function()
            vim.api.nvim_create_user_command("Lsp", function()
                require("klsp").setup()
            end, {})

            vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "",
                },
            })

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(s)
                        luasnip.lsp_expand(s.body)
                    end,
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),

                mapping = {
                    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                },

                experimental = {
                    ghost_text = true,
                },
            })

            cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
            cmp.setup.cmdline(":", { sources = { { name = "cmdline" }, { name = "path" } } })
        end,
    },
}

require("unnamed").setup({
    workdir = unnamed_path,
    repos = plugins,
})
