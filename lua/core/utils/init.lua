local M = {}

-- Sets main options from options (table)
M.vim_opts = function(options)
    if options ~= nil then
        for scope, table in pairs(options) do
            for setting, value in pairs(table) do
                vim[scope][setting] = value
            end
        end
    end
end

-- set keybinds
M.map = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end

-- helper for cmp completions
M.has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- TODO: Setup to work with FTerm instead of ToggleTerm
M.create_floating_terminal = function(term, cmd) end

-- updates all Mason packages
M.updateMason = function()
    local registry = require("mason-registry")
    registry.refresh()
    registry.update()
    local packages = registry.get_all_packages()
    for _, pkg in ipairs(packages) do
        if pkg:is_installed() then
            pkg:install()
        end
    end
end

-- updates everything in FunctNvim
M.updateAll = function()
    vim.notify("Pulling latest changes...")
    vim.fn.jobstart({ "git", "pull", "--rebase" })
    require("lazy").sync({ wait = true })
    vim.notify("Updating Mason packages...")
    M.updateMason()
    -- make sure treesitter is loaded so it can update parsers
    require("nvim-treesitter")
    vim.cmd("TSUpdate")
    vim.notify("FunctNvim updated!", "info")
end

-- Chech if the attached LSP supports formatting
M.supports_formatting = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
            return true
        end
    end
    return false
end

-- check if option to disable is active from specified group
M.enabled = function(group, opt)
    return group == nil or group[opt] == nil or group[opt] == true
end

return M
