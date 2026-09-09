-- minimal git-gutter: shows +/~/_ signs for lines added/changed/deleted
-- against HEAD, using `git diff --unified=0` on the file on disk.
--
-- This only reflects what's saved to disk, not unsaved buffer edits --
-- keeping it simple means not reimplementing git's diff algorithm on
-- in-memory buffer content.

local ns = vim.api.nvim_create_namespace("kgit")

local function clear(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function place_hunks(bufnr, diff_output)
    clear(bufnr)
    for old_count, new_start, new_count in
        diff_output:gmatch("@@ %-%d+,?(%d*) %+(%d+),?(%d*) @@")
    do
        old_count = old_count == "" and 1 or tonumber(old_count)
        new_start = tonumber(new_start)
        new_count = new_count == "" and 1 or tonumber(new_count)

        if new_count == 0 then
            -- pure deletion: mark the line it would've preceded
            vim.api.nvim_buf_set_extmark(bufnr, ns, math.max(new_start, 0), 0, {
                sign_text = "_",
                sign_hl_group = "GitSignsDelete",
            })
        else
            local hl = (old_count == 0) and "GitSignsAdd" or "GitSignsChange"
            local sign = (old_count == 0) and "+" or "~"
            for i = 0, new_count - 1 do
                vim.api.nvim_buf_set_extmark(bufnr, ns, new_start - 1 + i, 0, {
                    sign_text = sign,
                    sign_hl_group = hl,
                })
            end
        end
    end
end

local function update(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" or vim.bo[bufnr].buftype ~= "" then
        return
    end

    local dir = vim.fn.fnamemodify(filename, ":h")

    vim.system(
        { "git", "-C", dir, "diff", "--no-color", "--no-ext-diff", "-U0", "--", filename },
        { text = true },
        function(res)
            if res.code ~= 0 then
                return
            end
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                    place_hunks(bufnr, res.stdout)
                end
            end)
        end
    )
end

local group = vim.api.nvim_create_augroup("kgit", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "FocusGained" }, {
    group = group,
    callback = function(args)
        update(args.buf)
    end,
})

return { update = update }
