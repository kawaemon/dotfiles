-- minimal git-gutter: shows +/~/_ signs for lines added/changed/deleted
-- against HEAD, using `git diff --unified=0` on the file on disk, plus a
-- keymap to preview a hunk's actual diff text.
--
-- This only reflects what's saved to disk, not unsaved buffer edits --
-- keeping it simple means not reimplementing git's diff algorithm on
-- in-memory buffer content.
--
-- Performance note: everything here scales with the *number of changed
-- lines*, never with total file size -- git computes the diff, we only
-- walk its (typically tiny) output. No buffer content is ever read to do
-- this, so it stays cheap on large files.

local ns = vim.api.nvim_create_namespace("kgit")

-- bufnr -> list of hunks, each { old_count, new_start, new_count, lines }
-- `lines` holds the raw "+"/"-" diff lines for that hunk (for preview_hunk).
local hunks_by_buf = {}

local MAX_PREVIEW_LINES = 200

local function clear_signs(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- Parses `git diff -U0` output into a list of hunks, keeping each hunk's
-- body lines around for preview_hunk() instead of throwing them away.
local function parse_hunks(diff_output)
    local hunks = {}
    local current
    for line in (diff_output .. "\n"):gmatch("([^\n]*)\n") do
        local old_count, new_start, new_count = line:match("^@@ %-%d+,?(%d*) %+(%d+),?(%d*) @@")
        if new_start then
            current = {
                old_count = old_count == "" and 1 or tonumber(old_count),
                new_start = tonumber(new_start),
                new_count = new_count == "" and 1 or tonumber(new_count),
                lines = {},
            }
            table.insert(hunks, current)
        elseif current and (line:sub(1, 1) == "+" or line:sub(1, 1) == "-") then
            table.insert(current.lines, line)
        end
    end
    return hunks
end

local function place_signs(bufnr, hunks)
    clear_signs(bufnr)
    for _, h in ipairs(hunks) do
        if h.new_count == 0 then
            -- pure deletion: mark the line it would've preceded
            vim.api.nvim_buf_set_extmark(bufnr, ns, math.max(h.new_start, 0), 0, {
                sign_text = "_",
                sign_hl_group = "GitSignsDelete",
            })
        else
            local hl = (h.old_count == 0) and "GitSignsAdd" or "GitSignsChange"
            local sign = (h.old_count == 0) and "+" or "~"
            for i = 0, h.new_count - 1 do
                vim.api.nvim_buf_set_extmark(bufnr, ns, h.new_start - 1 + i, 0, {
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
                if not vim.api.nvim_buf_is_valid(bufnr) then
                    return
                end
                local hunks = parse_hunks(res.stdout)
                hunks_by_buf[bufnr] = hunks
                place_signs(bufnr, hunks)
            end)
        end
    )
end

-- Finds the hunk covering the cursor's line, if any. Hunks are in
-- ascending line order (that's the order git emits them in), so this can
-- stop as soon as it has passed the cursor line.
local function hunk_at_cursor()
    local bufnr = vim.api.nvim_get_current_buf()
    local hunks = hunks_by_buf[bufnr]
    if not hunks then
        return nil
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    for _, h in ipairs(hunks) do
        if h.new_start > lnum then
            break
        end
        local first, last
        if h.new_count == 0 then
            first, last = h.new_start + 1, h.new_start + 1
        else
            first, last = h.new_start, h.new_start + h.new_count - 1
        end
        if lnum >= first and lnum <= last then
            return h
        end
    end
    return nil
end

local preview_win

local function close_preview()
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
    end
    preview_win = nil
end

local function preview_hunk()
    close_preview()

    local h = hunk_at_cursor()
    if not h then
        vim.notify("kgit: no hunk under cursor", vim.log.levels.INFO)
        return
    end

    local lines = h.lines
    local truncated = false
    if #lines > MAX_PREVIEW_LINES then
        lines = vim.list_slice(lines, 1, MAX_PREVIEW_LINES)
        truncated = true
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    if truncated then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "... (truncated)" })
    end
    vim.bo[buf].filetype = "diff"
    vim.bo[buf].bufhidden = "wipe"

    local width = 20
    for _, l in ipairs(lines) do
        width = math.max(width, #l)
    end
    width = math.min(width, math.floor(vim.o.columns * 0.8))
    local height = math.min(#lines + (truncated and 1 or 0), 20)

    preview_win = vim.api.nvim_open_win(buf, false, {
        relative = "cursor",
        row = 1,
        col = 0,
        width = width,
        height = height,
        style = "minimal",
        border = "single",
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" }, {
        once = true,
        callback = close_preview,
    })
end

local group = vim.api.nvim_create_augroup("kgit", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "FocusGained" }, {
    group = group,
    callback = function(args)
        update(args.buf)
    end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
        hunks_by_buf[args.buf] = nil
    end,
})

vim.api.nvim_create_user_command("GitPreviewHunk", preview_hunk, {})

-- K is the de-facto "show me more about this" key across the vim/nvim
-- ecosystem (LSP hover, gitsigns' own default). Reused here for hunk
-- preview; does nothing when the cursor isn't on a hunk (no more falling
-- back to man-page lookup).
vim.keymap.set("n", "K", function()
    if hunk_at_cursor() then
        preview_hunk()
    end
end, { noremap = true, silent = true })

return { update = update, preview_hunk = preview_hunk }
