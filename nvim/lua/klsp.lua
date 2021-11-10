local M = {}

M.setup = function()
    vim.cmd("set completeopt=menu,menuone,noselect")
    vim.diagnostic.config({
        virtual_text = {
            prefix = "",
            spacing = 0,
            format = function(diagnostic)
                local severity = ""

                if diagnostic.severity == vim.diagnostic.severity.ERROR then
                    severity = "E"
                elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                    severity = "W"
                elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                    severity = "I"
                elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                    severity = "H"
                end

                return string.format("%s: %s", severity, diagnostic.message)
            end
        }
    })

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    cmp.setup({
        snippet = {
            expand = function(s) luasnip.lsp_expand(s.body) end
        },

        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" }
        }, {
            { name = "buffer" },
        }),

        mapping = {
            ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }
    })

    cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
    cmp.setup.cmdline(":", { sources = { { name = "cmdline" }, { name = "path" } } })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

    lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attatch = function()
            print("clangd is attached")
        end,
    })

    lspconfig.rust_analyzer.setup({
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
        capabilities = capabilities,
        on_attatch = function()
            print("rust-analyzer is attached")
        end,
        settings = {
            ["rust-analyzer"] = {
                procMacro = { enable = true },
                checkOnSave = { command = "clippy" }
            }
        }
    })

    lspconfig.gopls.setup({
        cmd = { "gopls", "serve", "--debug=localhost:6060" },
        capabilities = capabilities,
        on_attatch = function()
            print("gopls is attached. Debugging is available at localhost:6060")
        end,
        settings = {
            gopls = {
                staticcheck = true,
            }
        }
    })

    vim.cmd([[
        command! -nargs=0 Hover :lua vim.lsp.buf.hover()
        command! -nargs=0 CodeAction :lua vim.lsp.buf.code_action()
        command! -nargs=0 Definition :lua vim.lsp.buf.definition()
        command! -nargs=0 Implementation :lua vim.lsp.buf.implementation()
        command! -nargs=0 Rename :lua vim.lsp.buf.rename()
        command! -nargs=0 References :lua vim.lsp.buf.references()
        autocmd BufWritePre * :lua vim.lsp.buf.formatting_sync()
    ]])
end

return M
