-- User configuration file to keep user preferenses modular

local M = {}

-- add none-ls sources
M.setup_sources = function(b)
	return {
		b.formatting.autopep,
		b.code_actions.gitsigns,
	}
end

-- Add sources to auto install
M.ensure_installed = {
	null_ls = {
		"stylua",
	}, -- TODO: Add other languages like TS,JS
	-- Add Dap?
	mason = {
		bashls = true,
		lua_ls = {
			Lua = {
				runtime = {
					version = "LuaJIT", -- Lua runtime version (If you using Nvim its likely LuaJIT)
					path = vim.split(package.path, ";"),
				},
				workspace = {
					library = {
						vim.env.VIMRUNTIME,
					},
					checkThirdParty = false,
				},
				diagnostic = {
					global = {
						"vim",
					},
				},
				telemetry = {
					enable = false,
				},
			},
		},
		intelephense = {
			settings = {
				environment = {
					includePaths = {
						"C:/PHP/includes",
					},
				},
			},
		},
		html = true,
		vimls = true,
		jsonls = {
			settings = {
				json = {
					schemes = require("schemastore").json.schemas(),
				},
				validate = {
					enable = true,
				},
			},
		},
		cmake = {},
		clangd = {
			keys = {
				{ "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
			},
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"Makefile",
					"configure.ac",
					"configure.in",
					"config.h.in",
					"meson.build",
					"meson_options.txt",
					"build.ninja"
				)(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
					fname
				) or require("lspconfig.util").find_git_ancestor(fname)
			end,
			capabilities = {
				offsetEncoding = { "utf-16" },
			},
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
		},
		powershell_es = {
			bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
			shell = "pwsh.exe",
			root_dir = function(fname)
				local path = require("lspconfig").util.root_pattern("*_profile.ps1") or "*.ps1"
				return path(fname)
			end,
			single_file_support = true,
		},
		svelte = true,
		emmet_language_server = {
			filetypes = { "html", "svelte", "astro", "javascriptreact", "typescriptreact", "xml" },
		},
		tsserver = {
			init_options = ts_util.init_options,
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},

			--[[ on_attach = function(client)
				-- TODO: Move custom attach functions to core.lsp_setup
				custom_attach(client)

				ts_util.setup({ auto_inlay_hints = false })
				ts_util.setup_client(client)
			end, ]]
		},
	},
}

-- Servers to be used for auto formatting
M.formatting_servers = {
	["lua_ls"] = { "lua" },
	["null_ls"] = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
}

M.options = {
	opt = {
		confirm = true,
	},
}

M.autocommands = {
	inlay_hints = true,
	trailing_whitespace = true,
	cmp = true,
}

-- TODO: build
M.enable_plugins = {}

-- TODO: build
M.plugins = {}

M.user_conf = function()
	vim.cmd([[
        autocmd VimEnter * lua vim.notify("Welcome to FunctNvim", "info", {title = "Neovim" })
    ]])
	-- require("user.autocmds")
end

return M
