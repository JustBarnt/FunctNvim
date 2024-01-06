--[[ local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt") ]]

local augroup = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

local exist, config = pcall(require, "user.config")
local group = exist and type(config) == "table" and config.autocommands or {}
local enabled = require("core.utils").enabled

-- Uses virt_text for inlays hints
if enabled(group, "inlay_hints") then
    cmd("LspAttach", {
        group = augroup("LspAttach_inlayhints", { clear = true }),
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("inlay-hints").on_attach(client, bufnr)
        end,
    })
end

-- Delete whitespace when saving buffer
if enabled(group, "trailing_whitespace") then
    cmd({ "BufWritePre" }, {
        desc = "Format to remove trailing whitespace on save.",
        group = augroup("Format Trailing Whitespace", { clear = true }),
        patern = { "*" },
        command = [[%s/\s\+$//e]],
    })
end

-- Maintain Buffer state: Cursor position, etc.
if enabled(group, "maintain_buffer_state") then
    augroup("Maintain Buffer State", { clear = true })
    cmd({ "BufWinLeave" }, {
        desc = "Maintain Buffer State",
        group = "Maintain Buffer State",
        pattern = { "*.*" },
        command = "mkview",
    })

    cmd({ "BufWinEnter" }, {
        desc = "Maintain Buffer State",
        group = "Maintain Buffer State",
        pattern = { "*.*" },
        command = "silent! loadview",
    })
end

-- Colors hexcodes and color namespace
if enabled(group, "colorized") then
    cmd({ "FileType" }, {
        desc = "Start Colorized",
        pattern = "*",
        group = augroup("colorized", { clear = true }),
        callback = function()
            require("colorizer").attach_to_buffer(0, {
                mode = "background",
                css = true,
            })
        end,
    })
end

-- Disable Autocomplete in certain files
if enabled(group, "cmp") then
    cmd({ "FileType" }, {
        desc = "Disable Autocomplete in specified file types",
        pattern = "gitcommit,gitrebase,text,markdown",
        group = augroup("cmp_disable", { clear = true }),
        command = "lua require('cmp').setup.buffer { enabled = false }",
    })
end

-- TODO: Potentially implement for other plugin buffers that don't need to be open as the last window
-- Close trouble when last window in buffer
cmd("BufEnter", {
    group = vim.api.nvim_create_augroup("TroubleClose", { clear = true }),
    callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if
            layout[1] == "leaf"
            and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "Trouble"
            and layout[3] == nil
        then
            vim.cmd("confirm quit")
        end
    end,
})
