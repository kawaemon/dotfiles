local M = {}

M.setup = function()
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/lsp/handlers.lua#L309
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/lsp/util.lua#L1439
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

    vim.api.nvim_set_keymap("n", "<C-k>", '<Cmd>lua require("klsp").hover()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-m>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })

    local function alias(key, f)
        vim.api.nvim_create_user_command(key, f, {})
    end

    alias("Rename", vim.lsp.buf.rename)
    alias("CodeAction", vim.lsp.buf.code_action)
    alias("Definition", vim.lsp.buf.definition)
    alias("References", vim.lsp.buf.references)
    alias("Implementation", vim.lsp.buf.implementation)

    -- setup python venv
    -- https://zenn.dev/misora/articles/d0e8c244f2f4db
    local venv_path = vim.fn.getcwd() .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 then
        vim.env.VIRTUAL_ENV = venv_path
        vim.env.PATH = venv_path .. '/bin:' .. vim.env.PATH
        vim.notify("lsp: venv found, appending to PATH")
    end

    local lspconfig = require("lspconfig")
    local cmp = require("cmp")
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
                vim.notify(attach_msg)

                if opts.on_attach then
                    opts.on_attach()
                end
            end,
        })
    end

    -- https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1941556771
    init_lsp("pyright", {
        settings = {
            pyright = {
                disableOrganizeImports = true, -- Using Ruff
            },
            python = {
                analysis = {
                    ignore = { '*' }, -- Using Ruff
                    typeCheckingMode = 'off', -- Using mypy
                },
            },
        }
    })
    init_lsp("ruff", {})
    init_lsp("ts_ls", {})
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
        cmd = { "/usr/bin/gopls", "serve", "--debug=localhost:6060" },
        additional_msg = "debugging is available at localhost:6060",
        settings = {
            ["gopls"] = { staticcheck = true },
        },
    })

    local function get_client_name(client_id)
        local clients = vim.lsp.get_active_clients()

        for _, client in ipairs(clients) do
            if client.id == client_id then
                return client.name
            end
        end

        return nil
    end

    -- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp", { clear = true }),
        callback = function(args)
            name = get_client_name(args.data.client_id)
            if name == "pyright" then
                return
            end

            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                  vim.lsp.buf.format({ async = false, id = args.data.client_id })
              end,
            })
        end
    })

    vim.cmd("LspStart")
end

M.hover = function()
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/diagnostic.lua#L1212
    -- https://github.com/neovim/neovim/blob/46bd48f7e902250dbccdea71ec6eb3888588133f/runtime/lua/vim/diagnostic.lua#L1346
    buffer = vim.diagnostic.open_float({ focusable = false })

    if buffer == nil then
        vim.lsp.buf.hover()
    end
end

return M
