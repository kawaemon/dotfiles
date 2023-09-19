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

    "kyazdani42/nvim-web-devicons",
    {
        repo = "kyazdani42/nvim-tree.lua",
        setup = function()
            vim.api.nvim_create_user_command("Tree", function() vim.cmd(":NvimTreeToggle") end, {})

            require("nvim-tree").setup({
                git = { ignore = false },
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
                                untracked = "󰐕",
                                deleted = "",
                                ignored = "",
                            }
                        }
                    }
                },
                on_attach =
                    function(bufnr)
                        local api = require('nvim-tree.api')

                        local function opts(desc)
                          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                        end

                        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
                        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
                        vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
                        vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
                        vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
                        vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
                        vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
                        vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
                        vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
                        vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
                        vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
                        vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
                        vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
                        vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
                        vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
                        vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
                        vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
                        vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
                        vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
                        vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
                        vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
                        vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
                        vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
                        vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
                        vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
                        vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
                        vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
                        vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
                        vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
                        vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
                        vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
                        vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
                        vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
                        vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
                        vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
                        vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
                        vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
                        vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
                        vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
                        vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
                        vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
                        vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
                        vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
                        vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
                        vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
                        vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
                        vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
                        vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
                        vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
                        vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
                        vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
                    end
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
