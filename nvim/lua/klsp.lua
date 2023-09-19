local M = {}

M.setup = function()
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/lsp/handlers.lua#L309
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/lsp/util.lua#L1439
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            focusable = false,
        }
    )

    vim.api.nvim_set_keymap("n", "<C-k>", '<Cmd>lua require("klsp").hover()<CR>', { noremap = true, silent = true })

    local function alias(key, f)
        vim.api.nvim_create_user_command("Rename", function()
            f()
        end, {})
    end

    alias("Rename", vim.lsp.buf.rename)
    alias("CodeAction", vim.lsp.buf.code_action)
    alias("Definition", vim.lsp.buf.definition)
    alias("References", vim.lsp.buf.references)
    alias("Implementation", vim.lsp.buf.implementation)

    local cmp = require("cmp")
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local init_lsp = function(name, opts)
        lspconfig[name].setup({
            cmd = opts.cmd,
            settings = opts.settings,
            capabilities = capabilities,
            on_attach = function(client)
                local attach_msg = "lsp: " .. name .. " is attached."
                if opts.additional_msg then
                    attach_msg = attach_msg .. " " .. opts.additional_msg
                end
                print(attach_msg)

                if opts.on_attach then
                    opts.on_attach()
                end
            end
        })
    end

    init_lsp("tsserver", {})
    init_lsp("clangd", {})

    init_lsp("rust_analyzer", {
        cmd = { "rust-analyzer" },
        settings = {
            ["rust-analyzer"] = {
                procMacro = { enable = true },
                checkOnSave = { command = "clippy" },
            },
        },
    })

    init_lsp("gopls", {
        cmd = { "gopls", "serve", "--debug=localhost:6060" },
        additional_msg = "debugging is available at localhost:6060",
        settings = {
            ["gopls"] = { staticcheck = true },
        },
    })

    vim.cmd("LspStart")
end

M.hover = function()
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/diagnostic.lua#L1212
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/diagnostic.lua#L1346
    buffer = vim.diagnostic.open_float({
        focusable = false
    })

    if buffer == nil then
        vim.lsp.buf.hover()
    end
end

return M
