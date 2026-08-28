local function list_files_cmd()
    if vim.fn.executable("fd") == 1 then
        return "fd --type f --strip-cwd-prefix"
    end
    if vim.fn.executable("rg") == 1 then
        return "rg --files"
    end
    return "find . -type f -not -path '*/.git/*' -printf '%P\\n'"
end

local function open_picker()
    if vim.fn.executable("fzf") ~= 1 then
        vim.notify("kfzf: fzf executable not found in PATH", vim.log.levels.ERROR)
        return
    end

    local result_file = vim.fn.tempname()
    local cmd = string.format("%s | fzf > %s", list_files_cmd(), result_file)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        style = "minimal",
        border = "single",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
    })

    vim.fn.jobstart(cmd, {
        term = true,
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end

            local lines = vim.fn.readfile(result_file)
            vim.fn.delete(result_file)

            local selected = lines[1]
            if selected == nil or selected == "" then
                return
            end

            vim.schedule(function()
                vim.cmd("edit " .. vim.fn.fnameescape(selected))
            end)
        end,
    })

    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Files", open_picker, {})

vim.keymap.set("n", "<C-p>", open_picker, { noremap = true, silent = true })
