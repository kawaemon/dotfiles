local M = {}

M.setup = function()
    vim.diagnostic.config({
        virtual_text = {
            prefix = "",
            spacing = 0,
            format = function(diag)
                local severity = ""

                if diag.severity == vim.diagnostic.severity.ERROR then
                    severity = "E"
                elseif diag.severity == vim.diagnostic.severity.WARN then
                    severity = "W"
                elseif diag.severity == vim.diagnostic.severity.INFO then
                    severity = "I"
                elseif diag.severity == vim.diagnostic.severity.HINT then
                    severity = "H"
                end

                return string.format("%s: %s", severity, diag.message)
            end
        }
    })

    local cmp = require("cmp")

    cmp.setup({
        snippet = {
            expand = function(a) require("luasnip").lsp_expand(a.body) end
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
    cmp.setup.cmdline(":", { sources = { { name = "path" } } })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup({
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
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
        settings = {
            gopls = {
                staticcheck = true,
            }
        }
    })
end

return M
