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

    vim.api.nvim_set_keymap("n", "K", '<Cmd>lua require("klsp").hover()<CR>', { noremap = true, silent = true })

    vim.cmd([[
        command! -nargs=0 CodeAction <Cmd>lua vim.lsp.buf.code_action()<CR>
        command! -nargs=0 Definition <Cmd>lua vim.lsp.buf.definition()<CR>
        command! -nargs=0 Implementation <Cmd>lua vim.lsp.buf.implementation()<CR>
        command! -nargs=0 Rename <Cmd>lua vim.lsp.buf.rename()<CR>
        command! -nargs=0 References <Cmd>lua vim.lsp.buf.references()<CR>
        LspStart
    ]])
end

M.hover = function()
    diagnostic = vim.diagnostic.open_float()
    if diagnostic == nil then
        vim.lsp.buf.hover()
    end
end

return M
