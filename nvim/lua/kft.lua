local M = {}

local handlers = {
    go = function()
        vim.bo.expandtab = false
    end
}

M.on_ft = function(ft)
    local handler = handlers[ft]
    if handler ~= nil then
        handler()
    end
end

return M
