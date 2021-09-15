-- Ryan Davis NeoVim 0.5 Lua Config
-- Inspiration from Ben Frain https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f

-- Dependencies
-- Plugins require Paq, a Lua package manager, installation found https://github.com/savq/paq-nvim
-- LSP servers must be installed for each language
-- Python = `npm install -g pyright`
-- JS/TS ESLint, Docker, Lua = `brew install efm-langserver`
-- TypeScript = `npm install -g typescript typescript-language-server`
-- Rust = Download from https://github.com/rust-analyzer/rust-analyzer/releases
--    rename `rust-analyzer` | chmod and put into path
-- Formatter also requires that each formmatter (black for Python) be installed as well

-- Lua variables for setting various commands, functions, etc.
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
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

-- Plugins
require("paq-nvim")({

  -- Theme
  -- "tanvirtin/monokai.nvim",
  "folke/tokyonight.nvim",

  -- Vim Diff on side/vim fugitive
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",

  -- Nvim LSP Server
  "neovim/nvim-lspconfig",
  "glepnir/lspsaga.nvim",

  -- Additional Linting
  "mfussenegger/nvim-lint",

  -- Status Line and Buffer Line in Lua
  "hoob3rt/lualine.nvim",
  "romgrk/barbar.nvim",

  -- File Tree
  "kyazdani42/nvim-tree.lua",
  "kyazdani42/nvim-web-devicons",

  -- Auto pairs and bracket surroundings
  "jiangmiao/auto-pairs",
  "blackCauldron7/surround.nvim",

  -- Commenting
  "b3nj5m1n/kommentary",

  -- "Hop" navigation
  "phaazon/hop.nvim",

  -- Debugger
  "puremourning/vimspector",
  "szw/vim-maximizer",

  -- Camelcase Movement
  "chaoren/vim-wordmotion",
  "bkad/CamelCaseMotion",

  -- HTML Tag completion
  -- https://docs.emmet.io/abbreviations/syntax/
  "mattn/emmet-vim",

  -- Autocompletion plugin
  "hrsh7th/nvim-compe",

  -- VSCode Snippet Feature in Nvim
  "hrsh7th/vim-vsnip",

  -- Formatter
  "mhartington/formatter.nvim",

  -- Telescope Finder
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "nvim-telescope/telescope.nvim",

  -- Treesitter for NeoVim
  "nvim-treesitter/nvim-treesitter",

  -- Package Manager
  "savq/paq-nvim",
})

-- Theme Config
g.tokyonight_style = "storm"
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
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " " },
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
g.nvim_tree_auto_close = 1
map("n", "<C-t>", ":NvimTreeToggle<cr>")

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
--[[
require "lspconfig".dockerls.setup(
  {
    cmd = {"docker-langserver", "--stdio"},
    filetypes = {"dockerfile", "Dockerfile"},
  }
) ]]

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

require("lspconfig").efm.setup({
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
vim.lsp.diagnostic.show_line_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_icon = " ",
  definition_preview_icon = "  ",
  dianostic_header_icon = "   ",
  error_sign = " ",
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = "",
})

map("n", "<Leader>cf", ":Lspsaga lsp_finder<CR>", { silent = true })
map("n", "<leader>ca", ":Lspsaga code_action<CR>", { silent = true })
map("v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", { silent = true })
map("n", "<leader>ch", ":Lspsaga hover_doc<CR>", { silent = true })
map("n", "<leader>ck", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', { silent = true })
map("n", "<leader>cj", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', { silent = true })
map("n", "<leader>cs", ":Lspsaga signature_help<CR>", { silent = true })
map("n", "<leader>ci", ":Lspsaga show_line_diagnostics<CR>", { silent = true })
map("n", "<leader>cn", ":Lspsaga diagnostic_jump_next<CR>", { silent = true })
map("n", "<leader>cp", ":Lspsaga diagnostic_jump_prev<CR>", { silent = true })
map("n", "<leader>cr", ":Lspsaga rename<CR>", { silent = true })
map("n", "<leader>cd", ":Lspsaga preview_definition<CR>", { silent = true })

-- Setup treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })

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

-- Debugger/Vimspector Config
map("n", "<leader>dp", "oimport pudb; pudb.set_trace()<Esc>")
map("n", "<leader>z", ":MaximizerToggle!<CR>")
g.vimspector_enable_mappings = "HUMAN"
map("n", "<leader>da", ":call vimspector#Launch()<CR>")

-- Camelcase Movement
g.camelcasemotion_key = "<leader>"
-- Need to figure these out
-- map("v", ",i", "<Esc>l,bv,e")
-- map("o", ",i", ":normal v,i<CR>")

-- Git fugitive
map("n", "<leader>gs", ":Git<CR>")
map("n", "<leader>gd", ":Gdiff<CR>")
map("n", "<leader>gf", ":diffget //3<CR>")
map("n", "<leader>gj", ":diffget //2<CR>")
map("n", "<leader>gc", ":Git commit<CR>")
map("n", "<leader>gp", ":Git push<CR>")

-- Copy and Paste from Clipboard
map("v", "<C-c", ":w !pbcopy<CR><CR>")
map("n", "<C-v", ":r !pbpaste<CR><CR>")

-- Autocompletion setup and start
require("compe").setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { "", "", "", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    luasnip = true,
  },
})
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif check_back_space() then
    return t("<Tab>")
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-p>")
  else
    return t("<S-Tab>")
  end
end

vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", { expr = true })
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- End Compe related setup

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
map("n", "<c-j>", "<cmd>m .+1<CR>", { silent = true })
map("n", "<c-k>", "<cmd>m .-2<CR>", { silent = true })
map("i", "<c-j> <Esc>", "<cmd>m .+1<CR>==gi", { silent = true })
map("i", "<c-k> <Esc>", "<cmd>m .-2<CR>==gi", { silent = true })
map("v", "<c-j>", "<cmd>m +1<CR>gv=gv", { silent = true })
map("v", "<c-k>", "<cmd>m -2<CR>gv=gv", { silent = true })

--Auto close tags
map("i", ",/", "</<C-X><C-O>")

--After searching, pressing escape stops the highlight
map("n", "<esc>", ":noh<cr><esc>", { silent = true })

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

-- Telescope File Pickers
map("n", "<leader>fs", '<cmd>lua require("telescope.builtin").find_files()<cr>')
map("n", "<leader>fg", '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map("n", "<leader>fr", '<cmd>lua require("telescope.builtin").grep_string()<cr>')
map("n", "<leader>ff", '<cmd>lua require("telescope.builtin").file_browser({ hidden = true })<cr>')
-- Telescope Vim Pickers
map("n", "<leader>vr", '<cmd>lua require("telescope.builtin").registers()<cr>')
map("n", "<leader>vm", '<cmd>lua require("telescope.builtin").marks()<cr>')
map("n", "<leader>vb", '<cmd>lua require("telescope.builtin").buffers()<cr>')
map("n", "<leader>vh", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map("n", "<leader>vs", '<cmd>lua require("telescope.builtin").search_history()<cr>')
map("n", "<leader>vt", '<cmd>lua require("telescope.builtin").treesitter()<cr>')
-- Telescope Git Pickers
map(
  "n",
  "<leader>is",
  '<cmd>lua require("telescope.builtin").git_status(require("telescope.themes").get_dropdown({}))<cr>'
)
map(
  "n",
  "<leader>ic",
  '<cmd>lua require("telescope.builtin").git_commits(require("telescope.themes").get_dropdown({}))<cr>'
)
map(
  "n",
  "<leader>ib",
  '<cmd>lua require("telescope.builtin").git_branches(require("telescope.themes").get_dropdown({}))<cr>'
)
-- Telescope LSP Pickers
map("n", "<leader>rr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>')

-- Formatter
-- Prettier
local prettier = function()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote" },
    stdin = true,
  }
end

-- Stylua
local stylua = function()
  return {
    exe = "stylua",
    args = { "--indent-width", 2, "--indent-type", "Spaces" },
    stdin = false,
  }
end

-- Dockerfile-utils
local dockerfile_utils = function()
  return {
    exe = "dockerfile-utils",
    args = { "format" },
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

-- ShFmt (WIP)
local shfmt = function()
  return {
    exe = "shfmt",
    args = { "-ci", "-s", "-bn" },
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
    markdown = { prettier },
    lua = { stylua },
    rust = { rustfmt },
    python = { black },
    sh = { shfmt },
    dockerfile = { dockerfile_utils },
  },
})

-- Runs Formatter on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.css,*.scss,*.md,*.html,*.lua,*.rs,*.py,*.sh,Dockerfile : FormatWrite
augroup END
]],
  true
)
