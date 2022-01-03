local M = {}

M.setup = function()
    local cmp = require("cmp")
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

    local init_lsp = function(name, additional_options)
        additional_options.capabilities = capabilities

        local old_on_attach = additional_options.on_attach
        if old_on_attach then
            -- seems to never called?
            additional_options.on_attach = function()
                print(string.format("%s is attached", name))
                old_on_attach()
            end
        end

        lspconfig[name].setup(additional_options)
    end

    init_lsp("tsserver", {})
    init_lsp("clangd", {})

    init_lsp("rust_analyzer", {
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
        settings = {
            ["rust-analyzer"] = {
                procMacro = { enable = true },
                checkOnSave = { command = "clippy" },
            },
        },
    })

    init_lsp("gopls", {
        cmd = { "gopls", "serve", "--debug=localhost:6060" },
        settings = {
            gopls = { staticcheck = true },
        },
    })


    vim.cmd([[
        command! -nargs=0 Hover :lua vim.lsp.buf.hover()
        command! -nargs=0 CodeAction :lua vim.lsp.buf.code_action()
        command! -nargs=0 Definition :lua vim.lsp.buf.definition()
        command! -nargs=0 Implementation :lua vim.lsp.buf.implementation()
        command! -nargs=0 Rename :lua vim.lsp.buf.rename()
        command! -nargs=0 References :lua vim.lsp.buf.references()
        command! -nargs=0 Format :lua vim.lsp.buf.formatting_sync()
        LspStart
    ]])
end

return M
