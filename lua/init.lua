print("Attempting to load Core...")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Get all Core related files or throw an error to nvim for each file that failed
-- to load
for _, source in ipairs({
    "core.options",
    "core.keymaps",
    "core.utils",
    "core.autocommands",
    "core.usercommands",
}) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
    end
end

-- Get user config
local exist, user_config = pcall(require, "user.config")
local group = exist and user_config.enable_plugins or {}

-- Redirect vim.notify to use the nofity plugin
if require("core.utils.utils").enabled(group, "notify") then
    vim.notify = require("notify")
end

-- Create a user command for updating all plugins, mason packages, and parsers
vim.api.nvim_create_user_command("FunctnUpdate", function()
    require("core.utils.utils").updateAll()
end, { desc = "Updates plugins, mason paclages, treesitter parsers" })

-- Setting our colorscheme
vim.cmd("colorscheme rose-pine")

-- If we have a user config, run our user config
if exist then
    user_config.user_conf()
end
