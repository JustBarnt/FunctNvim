local map = require("core.utils").map

local config = require("user.config")
local config_found = pcall(require, config)
local group = config_found and type(config) == "table" and config.enable_plugins or {}
local recommended = config_fouind and type(config) == "table" and config.recommended or false
local enabled = require("core.utils").enabled

vim.g.mapleader = " " -- Leader: <Space>
vim.g.maplocalleader = " " -- Local Leader: <Space>

local M = {}

-- Disable bind for Macros as it causes issues with CMP (Autocompletion)
map("n", "q", "<Nop>")
map("n", "Q", "<Nop>")

-- My recommened keymaps
if enabled(recommended) then
    map({ "n", "t" }, "<C-h>", [[<Cmd>wincmd h<CR>]], "Move Pane: Left") -- Jump to left split
    map({ "n", "t" }, "<C-j>", [[<Cmd>wincmd j<CR>]], "Move Pane: Down") -- Jump to bottom split
    map({ "n", "t" }, "<C-k>", [[<Cmd>wincmd k<CR>]], "Move Pane: Up") -- Jump to top split
    map({ "n", "t" }, "<C-l>", [[<Cmd>wincmd l<CR>]], "Move Pane: Right") -- Jump to right split
    map("n", "<leader>sc", ':let @/ = ""<CR>') -- Clears search highlighting
    map("n", "_gc", "<cmd><C-U>call CommentOperator(visualmode())<CR>") -- Fix issues between nvims matchit and nvim-comment
    map("n", "Y", "y$") -- Yank to EOL
    map("n", "n", "nzz") -- Centers cursor when navigating seach results
    map("n", "N", "Nzz") -- Centers cursor when navigating seach results
    map("x", "<leader>p", [["_dP]]) -- Greatest remap ever - Name: theprimeagen
    map("n", "J", "mzJ`z") -- Center when joining lines
    map("i", "jk", "<ESC>", { silent = true, desc = "Return to normal mode" }) -- Easy return to normal
    map("v", "J", ":m '>+1<CR>gv=gv", { silent = true }) -- Move entire line down
    map("v", "K", ":m '<-2<CR>gv=gv", { silent = true }) -- Move entire line up
    map("n", "<leader>bv", ":vsplit <CR>") -- Split buffer vertically
    map("n", "<leader>x", "<cmd>bd<CR>", "Close Current Buffer") -- Close current buffer
    map("n", "<leader>X", "<cmd>bufdo bd<CR>", "Close All Buffers") -- Close all buffers
    map("n", "<leader>pv", vim.cmd.Ex, "Show File Explorer") -- Show Netrw
    map("n", "<leader>L", ":Lazy <CR>", "[L]azy Show") -- Show LazyUtilCore

    -- Movement in Insert mode
    map("i", "<C-b>", "<C-o>0") -- Move to start if the line
    map("i", "<C-a>", "<C-o>A") -- Move to end of line
end

-- FTerm
if enabled(group, "FTerm") then
    map("t", "jk", [[<C-\><C-n>]], { silent = true })
    map("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
    map("t", "<C-w>", [[<C-\><C-n><C-w>]], { silent = true })
end

-- Trouble
if enabled(group, "Trouble") then
    local opts = {
        desc = {
            o = "[T]rouble Toggle",
            ws = "[T]oggle [W]orkspace Diagnostics",
            doc = "[T]oggle [D]ocument Diagnostics",
            qf = "[T]oggle [Q]uick Fix",
            lsp = "[T]oggle LSP References",
            x = "[T]oggle Close",
        },
        silent = true,
    }

    map("<leader>tt", "<CMD>TroubleToggle <CR>", { desc = opts.desc.o, opts.silent })
    map("<leader>tw", "<CMD>TroubleToggle workspace_diagnostics<CR>", { desc = opts.ws, opts.silent })
    map("<leader>td", "<CMD>TroubleToggle document_diagnostics<CR>", { desc = opts.doc, opts.silent })
    map("<leader>tq", "<CMD>TroubleToggle quickfix<CR>", { desc = opts.qf, opts.silent })
    map("<leader>tx", "<CMD>TroubleClose <CR>", { desc = opts.x, opts.silent })
    map("<leader>tl", "<CMD>TroubleToggle lsp_references<CR>", { desc = opts.lsp, opts.silent })
end

-- Todo-Comments
if enabled(group, "Todo") then
    map("n", "<leader>tc", "<CMD>TodoTrouble<CR>", { desc = "[T]odo [T]rouble", silent = true })
    map("n", "<leader>tC", "<CMD>TodoTrouble keywords=TODO<CR><CR>", { desc = "[T]odo: Show TODO's", silent = true })
    map("n", "<leader>st", "<CMD>TodoTelescope<CR>", { desc = "[S]earch [T]odods", silent = true })
end

-- TODO: use TelescopeUI instead of Harpoons default UI
-- Harpoon: Name - theprimeagen
if enabled(group, "Harpoon") then
    local harpoon = require("harpoon")

    -- Append current buffer to HarpoonList
    map("n", "<leader>ha", function()
        harpoon:list():append()
    end, { desc = "[H]arpoon [A]dd", silent = true })

    -- Toggle a UI popup of or current harpooned items.
    map("n", "<leader>hl", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "[H]arpoon [L]ist", silent = true })

    -- Setup keymaps for using <leader>1-5 as keys to jump to that harpoon items
    -- Also supports opening in a Vertical Split
    for i = 1, 5 do
        map("n", string.format("<leader>%s", i), function()
            harpoon:list():select(i)
        end, { desc = "Harpoon: Jump To File: [" .. i .. "]", silent = true })

        map("n", string.format("<leader>hs%s", i), function()
            local buf_name = harpoon:list():get(i).value
            vim.cmd.vsplit(buf_name)
        end, { desc = "Harpoon: [S]plit File: [" .. i .. "] Right" })
    end
end

-- LSP-Zero
if enabled(group, "LspZero") then
    -- require("lsp-zero")
end

-- Telescope
if enabled(group, "Telescope") then
    local telescope_modules = require("core.utils").telescope_modules

    map("n", "<leader>gf", telescope_modules.builtin.git_files, { desc = "Search [G]it [F]iles" })
    map("n", "<leader>sf", telescope_modules.builtin.find_files, { desc = "[S]earch [F]iles" })
    map("n", "<leader>sh", telescope_modules.builtin.help_tags, { desc = "[S]earch [H]elp" })
    map("n", "<leader>sw", telescope_modules.builtin.grep_string, { desc = "[S]earch current [W]ord" })
    map("n", "<leader>sg", telescope_modules.builtin.live_grep, { desc = "[S]earch by [G]rep" })
    map("n", "<leader>sd", telescope_modules.builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    map("n", "<leader>sr", telescope_modules.builtin.resume, { desc = "[S]earch [R]esume" })

    map("n", "<leader>?", telescope_modules.builtin.oldfiles, { desc = "Find recently opened files" })
    map("n", "<leader><space>", telescope_modules.builtin.buffers, { desc = "Find existing buffers" })
    map("n", "<leader>/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        telescope_modules.builtin.current_buffer_fuzzy_find(telescope_modules.themes.get_dropdown({
            winblend = 3,
            previewer = false,
        }))
    end, { desc = "Fuzzily search in current buffer" })

    map("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "[F]ile [B]rowser" })
end

return M
