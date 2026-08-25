vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = -30
vim.g.netrw_browse_split = 4
vim.g.netrw_hide = 0

vim.api.nvim_create_user_command("Tree", function()
    vim.cmd("Lexplore")
end, {})

vim.keymap.set("n", "<C-n>", ":Lexplore<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function(data)
        if vim.fn.argc() ~= 0 then
            return
        end

        local has_name = data.file ~= "" or vim.bo[data.buf].buftype ~= ""
        if has_name then
            return
        end

        vim.cmd("Lexplore")
    end,
})

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(w)
            if vim.bo[buf].filetype == "netrw" then
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
