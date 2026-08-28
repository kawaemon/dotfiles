vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = -30
vim.g.netrw_browse_split = 4
vim.g.netrw_hide = 0

-- Reveal a file inside an open netrw tree window, expanding ancestor
-- directories on demand (netrw has no built-in "follow current file").
-- Rather than parsing the tree-drawing indentation ourselves, this asks
-- netrw's own NetrwTreePath/NetrwGetWord (exposed via netrw#Call) what
-- path a given line represents, and reuses NetrwBrowseChgDir +
-- netrw#LocalBrowseCheck -- the same functions its <CR> mapping calls --
-- to expand a directory.

local function netrw_call(fn, ...)
    return vim.fn["netrw#Call"](fn, ...)
end

-- Full path of the entry displayed on the current line.
local function line_path(treetop)
    local word = netrw_call("NetrwGetWord")
    local dir = netrw_call("NetrwTreePath", treetop)
    if word:sub(-1) == "/" then
        return dir
    end
    return dir .. word:gsub("[@=|*]$", "")
end

local function find_tree_win()
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "netrw" then
            return w
        end
    end
    return nil
end

local function expand_dir_under_cursor()
    local dirname = netrw_call("NetrwBrowseChgDir", 1, netrw_call("NetrwGetWord"), 1)
    vim.fn["netrw#LocalBrowseCheck"](dirname)
end

local function tree_reveal(target)
    local tree_win = find_tree_win()
    if not tree_win then
        return
    end

    vim.api.nvim_win_call(tree_win, function()
        local treetop = vim.w.netrw_treetop or vim.b.netrw_curdir
        if not treetop then
            return
        end
        treetop = (vim.fn.fnamemodify(treetop, ":p"):gsub("/+$", ""))

        local abs = vim.fn.fnamemodify(target, ":p")
        if abs:sub(1, #treetop + 1) ~= treetop .. "/" then
            return
        end
        local parts = vim.split(abs:sub(#treetop + 2), "/", { plain = true })

        for idx, part in ipairs(parts) do
            local is_last = idx == #parts
            local wanted = treetop .. "/" .. table.concat(parts, "/", 1, idx) .. (is_last and "" or "/")

            local lines = vim.api.nvim_buf_get_lines(0, vim.w.netrw_bannercnt - 1, -1, false)
            local found
            for i, line in ipairs(lines) do
                if line:find(part, 1, true) then
                    vim.api.nvim_win_set_cursor(0, { vim.w.netrw_bannercnt - 1 + i, 0 })
                    if line_path(treetop) == wanted then
                        found = vim.w.netrw_bannercnt - 1 + i
                        break
                    end
                end
            end
            if not found then
                return
            end
            vim.api.nvim_win_set_cursor(0, { found, 0 })

            if is_last then
                vim.cmd("normal! zz")
            else
                local treedict = vim.w.netrw_treedict or {}
                local already_open = treedict[wanted] ~= nil or treedict[wanted:sub(1, -2)] ~= nil
                if not already_open then
                    expand_dir_under_cursor()
                end
            end
        end
    end)
end

local function reveal_current_buffer()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return
    end
    tree_reveal(name)
end

local function toggle_tree()
    local name = vim.api.nvim_buf_get_name(0)
    vim.cmd("Lexplore")
    if name ~= "" then
        tree_reveal(name)
    end
end

vim.api.nvim_create_user_command("Tree", toggle_tree, {})

vim.keymap.set("n", "<C-n>", toggle_tree, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(data)
        if vim.bo[data.buf].filetype == "netrw" or vim.bo[data.buf].buftype ~= "" then
            return
        end
        reveal_current_buffer()
    end,
})

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

        local win = vim.api.nvim_get_current_win()
        vim.cmd("Lexplore")
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
        end
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
