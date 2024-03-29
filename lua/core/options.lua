local vim_opts = require("core.utils").vim_opts

-- disables certain messages | h: messages
vim.opt.shortmess:append("sIW")

--TODO: Add python3_host_prog

vim_opts({
    opt = {
        -- Editor / Command options
        number = true, -- Enables line numbers in the editor
        relativenumber = true, -- Displays number relative to your cursor position, useful for learning quick vertical movments
        numberwidth = 2, -- Min num of cols to use line numbers
        wildmode = "longest:full", -- Completion mode used for the char specified with "wildchar"
        wildoptions = "pum", -- Effects how cmdline-completion is done
        termguicolors = true, -- Enables 24-bit RBG color in TUI
        showmode = false, -- When enabled puts message on last line when in I, R, or V mode
        showcmd = true, -- Show partial command in the last line of the screen. Disable is terminal is slower
        cmdheight = 0, -- Num of Screen lines to use for the command-line
        incsearch = true, -- Makes search pattern highlight as it fines matches,
        showmatch = true, -- Highlights {},[],() when cursors is selecting it
        ignorecase = true, -- Ignores case when searching
        smartcase = true, -- Typing a capital letting when searching turns it case sensitive
        hidden = true, -- Buffers are not deleted unless using :bd or :BD
        equalalways = false, -- When false, Neovim will not resize windows
        splitright = true, -- Horizontal Spitting defaults to the right unless told otherwise
        splitbelow = true, -- Vertical Splitting defaults to the bottom unless told otherwise
        updatetime = 1000, -- Update time for writing swapfile to disc (if enabled) as well as CursorHold
        hlsearch = true, -- Highlights what you search for
        scrolloff = 5, -- Amount of lines below curor
        cursorline = true, -- Highlights current line
        wrap = false, -- Line wrapping when lines longer than the width of the window
        clipboard = "unnamedplus", -- Yanked items are copied to system clipboard, also allows pasting from clipboard
        inccommand = "split", -- When set displays results from :s, :smagic, etc
        swapfile = false, -- Disables swapfile
        mouse = "a", -- a = Mouse enabled for all modes
        fillchars = { eob = "~" }, -- Char to fill statuslien, vert sep, special lines in the window
        diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }, -- Settings of diff mode. :h diffopt
        undofile = true, -- Automatically saves history to an undo file when writting a buffer to memory
        signcolumn = "yes", -- When and how to draw signcolumn
        colorcolumn = "120", -- Draws a column on the screen at the specified width

        -- Tab options
        autoindent = true, -- Copies indent level from current line when starting a new line
        cindent = true, -- Enables automatic C program indenting,
        tabstop = 4, -- Spaces a <Tab> in the file counts for
        shiftwidth = 4, -- Number of spaces to use for each step of (auto)indent
        softtabstop = 4, -- Number of spaces a <Tab> counts for when performing editing operations
        expandtab = true, -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>
    },
})

local exist, config = pcall(require, "user.config") and type(config) == "table"
local opts = exist and config.options or {}
vim_opts(opts)
