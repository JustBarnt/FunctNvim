local exists = pcall(require, "user.config")
local config = require("user.config")
local group = exists and type(config) == "table" and config.usercommands or {}
local enabled = require("core.utils").enabled
local usercmd = vim.api.nvim_create_user_command

local M = {}

return M
