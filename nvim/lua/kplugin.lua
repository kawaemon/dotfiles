local uv = vim.loop

local unnamed_path = vim.env.HOME .. "/.config/nvim/unnamed"
local stat, err = uv.fs_stat(unnamed_path)
if stat == nil then
    print("installing unnamed")
    vim.fn.system("git clone https://github.com/approvers/unnamed.git " .. unnamed_path)
end

vim.o.runtimepath = vim.o.runtimepath .. "," .. unnamed_path

local unnamed = require("unnamed")

local plugins = {
    {
        repo = "kyazdani42/nvim-web-devicons",
        setup = function()
            require('nvim-web-devicons').setup()
        end
    },
    {
        repo = "ishan9299/nvim-solarized-lua",
        setup = function()
            vim.cmd("colorscheme solarized-flat")
        end
    },
    {
        repo = "kdheepak/tabline.nvim",
        setup = function()
            require('tabline').setup({ enable = true })
        end
    },
    {
        repo = "nvim-lualine/lualine.nvim",
        setup = function()
            require('lualine').setup({ theme = 'solarized_dark' })
        end
    },
    {
        repo = "kdheepak/lazygit.nvim",
        setup = function()
            vim.api.nvim_create_user_command("Lg", function() vim.cmd(":LazyGit") end, {})
        end
    },
    {
        repo = "lewis6991/gitsigns.nvim",
        setup = function()
            require('gitsigns').setup()
            vim.api.nvim_create_user_command(
                "Blame",
                function() vim.cmd("Gitsigns toggle_current_line_blame") end,
                {}
            )
        end
    },
    {
        repo = "kyazdani42/nvim-tree.lua",
        setup = function()
            vim.api.nvim_create_user_command("Tree", function() vim.cmd(":NvimTreeToggle") end, {})

            require("nvim-tree").setup({
                open_on_setup = true,
                renderer = {
                    special_files = {},
                    icons = {
                        show = {
                            git = true,
                            file = false,
                            folder = true,
                            folder_arrow = true,
                        },
                        glyphs = {
                            git = {
                                unstaged = "",
                                staged = "",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "",
                                deleted = "",
                                ignored = "",
                            }
                        }
                    }
                },
                view = {
                    mappings = {
                        -- disable default 's' key mapping (opens file with system default editor)
                        list = { { key = "s" } }
                    }
                }
            })
        end
    },
    {
        repo = "lukas-reineke/indent-blankline.nvim",
        setup = function()
            require('indent_blankline').setup({
                show_current_context = true,
            })
        end
    },
    {
        repo = "easymotion/vim-easymotion",
        setup = function()
            vim.api.nvim_set_keymap("n", "ss", "<Plug>(easymotion-s2", {})
        end
    },
    {
        repo = "junegunn/fzf.vim",
        setup = function()
            vim.api.nvim_create_user_command(
                "F",
                function() vim.cmd("Files") end,
                {}
            )
        end
    },

    -- #### tree-sitter ####
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/playground",
    {
        repo = "nvim-treesitter/nvim-treesitter",
        setup = function()
            vim.cmd([[
                hi! clear TSError
                hi TSError gui=underline guifg=#dc322f
            ]])

            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
                playground = { enable = true },
            })
        end
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
            require('trouble').setup()
        end
    },

    {
        repo = "hrsh7th/nvim-cmp",
        setup = function()
            vim.api.nvim_create_user_command(
                "Lsp",
                function() require("klsp").setup() end,
                {}
            )

            vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
            vim.diagnostic.config({ virtual_text = false })

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(s) luasnip.lsp_expand(s.body) end
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),

                mapping = {
                    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                },

                experimental = {
                    ghost_text = true,
                },
            })

            cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
            cmp.setup.cmdline(":", { sources = { { name = "cmdline" }, { name = "path" } } })
        end
    }
}

unnamed.setup({
    workdir = unnamed_path,
    repos = plugins
})