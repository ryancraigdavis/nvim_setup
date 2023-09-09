-- Ryan Davis NeoVim 0.9.1 Lua Config

-- Dependencies
-- Plugins require Packer, a Lua package manager, installation found https://github.com/wbthomason/packer.nvim
-- LSP servers, debuggers, linters, and formatters are managed with Mason

-- Lua variables for setting various commands, functions, etc.
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs)
end

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

-- Map leader to space
g.mapleader = " "

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- Plugins
require("packer").startup(function(use)

  -- Theme
  use "folke/tokyonight.nvim"

  -- Vim Diff on side/vim fugitive
  use "airblade/vim-gitgutter"
  use "kdheepak/lazygit.nvim"

  -- Nvim LSP Server
  use "neovim/nvim-lspconfig"
  use "williamboman/mason-lspconfig.nvim"

  -- Additional Linting
  use "mfussenegger/nvim-lint"

  -- Status Line and Buffer Line in Lua
  use "hoob3rt/lualine.nvim"
  use "romgrk/barbar.nvim"

  -- Github Copilot
  -- use "github/copilot.vim"
  use "zbirenbaum/copilot.lua"
  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  }
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

  -- File Tree
  use "kyazdani42/nvim-tree.lua"
  use "kyazdani42/nvim-web-devicons"

  -- LSP Diagnostics Config
  use "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim"


  -- Auto pairs and bracket surroundings
  use "jiangmiao/auto-pairs"
  use {
    "ur4ltz/surround.nvim",
    config = function()
      require"surround".setup {mappings_style = "sandwich"}
    end
  }

  -- Commenting
  use "b3nj5m1n/kommentary"

  -- "Hop" navigation
  use "phaazon/hop.nvim"

  -- Debugger
  use "williamboman/mason.nvim"
  use "mfussenegger/nvim-dap"
  use "mfussenegger/nvim-dap-python"
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use "szw/vim-maximizer"

  -- Camelcase Movement
  use "chaoren/vim-wordmotion"
  use "bkad/CamelCaseMotion"

  -- HTML Tag completion
  -- https://docs.emmet.io/abbreviations/syntax/
  use "mattn/emmet-vim"

  -- Autocompletion plugin
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"
  use "f3fora/cmp-spell"
  use "ray-x/cmp-treesitter"
  use "hrsh7th/cmp-nvim-lua"
  use "windwp/nvim-autopairs"

  -- VSCode Snippet Feature in Nvim
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"
  use "onsails/lspkind-nvim"

  -- Formatter
  use "mhartington/formatter.nvim"

  -- Telescope Finder
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-telescope/telescope.nvim"
  use "jvgrootveld/telescope-zoxide"

  -- Treesitter for NeoVim
  use "nvim-treesitter/nvim-treesitter"

  -- If not setup, run PackerSync
  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- Theme Config
g.tokyonight_style = "night"
g.tokyonight_italic_comments = true

opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.

-- Load the colorscheme
vim.cmd([[colorscheme tokyonight]])

-- Lualine Config
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "tokyonight",
    component_separators = { "∙", "∙" },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode", "paste" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      { "filename", file_status = true, full_path = true },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.cyan,
      },
    },
    lualine_x = { "filetype" },
    lualine_y = {
      {
        "progress",
      },
    },
    lualine_z = {
      {
        "location",
        icon = "",
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

-- File Tree for Nvim
map("n", "<C-t>", ":NvimTreeToggle<cr>")
require("nvim-tree").setup({})

-- Hop
require("hop").setup()
map("n", "<leader>j", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "<leader>l", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "<leader>j", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "<leader>l", "<cmd>lua require'hop'.hint_lines()<cr>")

-- Surround
require("surround").setup({})

-- LSP this is needed for LSP completions in CSS along with the snippets plugin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

-- Mason LSP/Debug/DAP manager
require("mason").setup()
require("mason-lspconfig").setup()

-- LSP Server config
require("lspconfig").pyright.setup({
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

require("lspconfig").rust_analyzer.setup({})

-- C++, Swift, and C
-- require'lspconfig'.sourcekit.setup{}
require'lspconfig'.clangd.setup{}

require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = {"vim"},
      }
    }
  }
})

require("lspconfig").cssls.setup({
  cmd = { "vscode-css-language-server", "--stdio" },
  capabilities = capabilities,
  settings = {
    scss = {
      lint = {
        idSelector = "warning",
        zeroUnits = "warning",
        duplicateProperties = "warning",
      },
      completion = {
        completePropertyWithSemicolon = true,
        triggerPropertyValueCompletion = true,
      },
    },
  },
})

-- Javascript/Typescript Configurations
require("lspconfig").tsserver.setup({
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    -- set_lsp_config(client)
  end,
})

-- ESLint config for the EFM server
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %m",
  },
  lintIgnoreExitCode = true,
}

-- Dockerfile EFM
local hadolint = {
  lintSource = "hadolint",
  lintCommand = "hadolint --no-color -",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintFormats = {
    "%f:%l %m",
  },
}

-- Yaml EFM
local yamllint = {
  lintSource = "yamllint",
  lintCommand = "yamllint -f parsable -",
  lintStdin = true,
}

-- Shell EFM (WIP)
local shellcheck = {
  lintSource = "shellcheck",
  lintCommand = "shellcheck -f gcc -x",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
}

require("lspconfig")["efm"].setup({
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    -- set_lsp_config(client)
  end,

  settings = {
    languages = {
      javascript = { eslint },
      javascriptreact = { eslint },
      ["javascript.jsx"] = { eslint },
      typescript = { eslint },
      ["typescript.tsx"] = { eslint },
      typescriptreact = { eslint },
      dockerfile = { hadolint },
      yaml = { yamllint },
      sh = { shellcheck },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "dockerfile",
    "yaml",
    "sh",
  },
})

-- LSP Prevents inline buffer annotations

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.open_float(nil, {
    source = 'always'
})
local nvim_lsp = require('lspconfig')
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end


map("n", "<leader>ce", '<cmd>lua vim.diagnostic.open_float()<CR>')
map("n", "<leader>cn", '<cmd>lua vim.diagnostic.goto_next()<CR>')
map("n", "<C-q>", '<Plug>(toggle-lsp-diag-vtext)')

-- Setup treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = {"python", "rust"}, highlight = { enable = true } })

-- Various options
opt.number = true
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.encoding = "utf-8" -- Set default encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.foldenable = false
opt.foldmethod = "indent"
opt.formatoptions = "l"
opt.hidden = true -- Enable background buffers
opt.hlsearch = true -- Highlight found searches
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing
opt.joinspaces = false -- No double spaces with join
opt.linebreak = true -- Stop words being broken on wrap
opt.list = false -- Show some invisible characters
opt.numberwidth = 5 -- Make the gutter wider by default
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.showmode = false -- Don't display mode
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true
opt.mouse = --Disables mouse mode

-- Use spelling for markdown files ‘]s’ to find next, ‘[s’ for previous, 'z=‘ for suggestions when on one.
-- Source: http:--thejakeharding.com/tutorial/2012/06/13/using-spell-check-in-vim.html
vim.api.nvim_exec(
  [[
augroup markdownSpell
    autocmd!
    autocmd FileType markdown,md,txt setlocal spell
    autocmd BufRead,BufNewFile *.md,*.txt,*.markdown setlocal spell
augroup END
]],
  false
)

-- HTML Tag completion
g.user_emmet_leader_key = "<C-w>"

-- Debugger/DAP Config
local dap = require('dap')
require("dapui").setup()
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/local/opt/llvm/bin/lldb-vscode',
  name = 'lldb'
}
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
--[[ dap.adapters.python = {
  type = 'executable';
  command = '/Users/ryandavis/.local/share/nvim/mason/packages/debugpy/debugpy';
  args = { '-m', 'debugpy.adapter' };
} ]]
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}
map("n", "<leader>da", ":call vimspector#Launch()<CR>")
-- require('dap').set_log_level('INFO')
dap.defaults.fallback.terminal_win_cmd = '20split new'
vim.fn.sign_define('DapBreakpoint',
                   {text = '🟥', texthl = '', linehl = '', numhl = ''})
vim.fn.sign_define('DapBreakpointRejected',
                   {text = '🟦', texthl = '', linehl = '', numhl = ''})
vim.fn.sign_define('DapStopped',
                   {text = '⭐️', texthl = '', linehl = '', numhl = ''})

vim.keymap.set('n', '<leader>dh',
               function() require"dap".toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dH',
               ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set({'n', 't'}, '<C-k>', function() require"dap".step_out() end)
vim.keymap.set({'n', 't'}, "<C-l>", function() require"dap".step_into() end)
vim.keymap.set({'n', 't'}, '<C-j>', function() require"dap".step_over() end)
vim.keymap.set({'n', 't'}, '<C-h>', function() require"dap".continue() end)
vim.keymap.set('n', '<leader>dn', function() require"dap".run_to_cursor() end)
vim.keymap.set('n', '<leader>dc', function() require"dap".terminate() end)
vim.keymap.set('n', '<leader>dR',
               function() require"dap".clear_breakpoints() end)
vim.keymap.set('n', '<leader>de',
               function() require"dap".set_exception_breakpoints({"all"}) end)
vim.keymap.set('n', '<leader>da', function() require"debugHelper".attach() end)
vim.keymap.set('n', '<leader>dA',
               function() require"debugHelper".attachToRemote() end)
vim.keymap
    .set('n', '<leader>di', function() require"dap.ui.widgets".hover() end)
vim.keymap.set('n', '<leader>d?', function()
    local widgets = require "dap.ui.widgets";
    widgets.centered_float(widgets.scopes)
end)
vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
vim.keymap.set('n', '<leader>dr',
               ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
vim.keymap.set('n', '<leader>du', ':lua require"dapui".toggle()<CR>')


map("n", "<leader>dp", "oimport pudb; pudb.set_trace()  # fmt: skip<Esc>")
map("n", "<leader>z", ":MaximizerToggle!<CR>")
-- Camelcase Movement
g.camelcasemotion_key = "<leader>"

-- LazyGit
map("n", "<leader>gs", ":LazyGit<CR>")

-- Copy and Paste from Clipboard
map("v", "<C-c", ":w !pbcopy<CR><CR>")
map("n", "<C-v", ":r !pbpaste<CR><CR>")

-- Config from https://github.com/whatsthatsmell/dots/blob/master/public%20dots/vim-nvim/lua/joel/completion/init.lua
-- completion maps (not cmp) --
-- line completion - use more!
map("i", "<c-l>", "<c-x><c-l>")
-- Vim command-line completion
map("i", "<c-v>", "<c-x><c-v>")
-- end non-cmp completion maps --

-- Setup nvim-cmp
local cmp = require("cmp")

-- lspkind
local lspkind = require("lspkind")
lspkind.init({
  mode = 'symbol_text',
  symbol_map = {
    Text = "",
    Method = "ƒ",
    Function = "ﬦ",
    Constructor = "",
    Variable = "",
    Class = "",
    Interface = "ﰮ",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "了",
    Keyword = "",
    Snippet = "﬌",
    Color = "",
    File = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
  },
})

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
    }),
    ["<Right>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
    }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i" }),
  },
  experimental = {
    ghost_text = true,
  },
  sources = {
    -- 'crates' is lazy loaded
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "vsnip" },
    { name = "path" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "spell" },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s %s", lspkind.presets.default[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "ﲳ",
        nvim_lua = "",
        treesitter = "",
        path = "ﱮ",
        buffer = "﬘",
        vsnip = "",
        spell = "暈",
      })[entry.source.name]

      return vim_item
    end,
  },
})

-- insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- Highlight on yank
cmd("au TextYankPost * lua vim.highlight.on_yank {on_visual = true}") -- disabled in visual mode

-- Quick new file
map("n", "<Leader>n", "<cmd>enew<CR>")

-- Easy select all of file
map("n", "<Leader>sa", "ggVG<c-$>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Easier file save
map("n", "<leader>w", "<cmd>:w<CR>")

-- Tab to switch buffers in Normal mode
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

-- Line bubbling
-- Use these two if you don't have prettier
--map('n'), '<c-j>', '<cmd>m .+1<CR>==')
--map('n,) <c-k>', '<cmd>m .-2<CR>==')
map("n", "<c-j>", "<cmd>m .+1<CR>")
map("n", "<c-k>", "<cmd>m .-2<CR>")
map("i", "<c-j> <Esc>", "<cmd>m .+1<CR>==gi")
map("i", "<c-k> <Esc>", "<cmd>m .-2<CR>==gi")
map("v", "<c-j>", "<cmd>m +1<CR>gv=gv")
map("v", "<c-k>", "<cmd>m -2<CR>gv=gv")

--Auto close tags
map("i", ",/", "</<C-X><C-O>")

--After searching, pressing escape stops the highlight
map("n", "<esc>", ":noh<cr><esc>")

-- Telescope Global remapping
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-w>"] = "delete_buffer",
        },
        n = {
          ["<C-w>"] = "delete_buffer",
        },
      },
    },
  },
})
require'telescope'.load_extension('zoxide')
-- Telescope File Pickers
map("n", "<leader>fs", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').grep_string()<cr>")
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').file_browser({ hidden = true })<cr>")
map("n", "<leader>ft", ":lua require'telescope'.extensions.zoxide.list{}<CR>")

-- Telescope Vim Pickers
map("n", "<leader>vr", "<cmd>lua require('telescope.builtin').registers()<cr>")
map("n", "<leader>vm", "<cmd>lua require('telescope.builtin').marks()<cr>")
map("n", "<leader>vb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
-- Telescope LSP Pickers
map("n", "<leader>rr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")

-- Formatter
-- Prettier
local prettier = function()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote" },
    stdin = true,
  }
end

-- Rustfmt
local rustfmt = function()
  return {
    exe = "rustfmt",
    args = { "--emit=stdout" },
    stdin = true,
  }
end

-- ShFmt
local shfmt = function()
  return {
    exe = "shfmt",
    args = { "-ci", "-s", "-bn" },
    stdin = true,
  }
end

--C++
local clang_format = function()
  return {
    exe = "clang-format",
    args = { "-i", vim.api.nvim_buf_get_name(0) },
    stdin = true,
  }
end

-- Black
local black = function()
  return {
    exe = "black",
    args = { "--quiet", "-" },
    stdin = true,
  }
end

require("formatter").setup({
  logging = false,
  filetype = {
    javascript = { prettier },
    typescript = { prettier },
    html = { prettier },
    css = { prettier },
    scss = { prettier },
    cpp = { clang_format },
    markdown = { prettier },
    rust = { rustfmt },
    python = { black },
    sh = { shfmt },
  },
})

-- Runs Formatter on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.css,*.scss,*.md,*.html,*.rs,*.py,*.sh: FormatWrite
augroup END
]],
  true
)
