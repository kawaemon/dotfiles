local M = {}

local noexpandtab = function()
    vim.bo.expandtab = false
end
local two_spaces = function()
    vim.bo.shiftwidth = 2
end

local handlers = {
    go = noexpandtab,
    typescript = two_spaces,
    typescriptreact = two_spaces,
}

M.on_ft = function(ft)
    local handler = handlers[ft]
    if handler ~= nil then
        handler()
    end
end

return M
