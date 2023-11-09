

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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)-- Plugins

require("lazy").setup({

  -- Theme
  "folke/tokyonight.nvim",
  "kdheepak/lazygit.nvim",

  -- Mason pkg manager
    "williamboman/mason.nvim",

  -- Nvim LSP Server
   "neovim/nvim-lspconfig" ,
   "williamboman/mason-lspconfig.nvim" ,

  -- Additional Linting
   "mfussenegger/nvim-lint" ,

  -- Status Line and Buffer Line in Lua
   "hoob3rt/lualine.nvim" ,
   "romgrk/barbar.nvim" ,

  -- Github Copilot
  -- use "zbirenbaum/copilot.lua"
   "github/copilot.vim" ,

  -- File Tree
   "kyazdani42/nvim-tree.lua" ,
   "kyazdani42/nvim-web-devicons" ,

  -- LSP Diagnostics Config
   "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim" ,


  -- Auto pairs and bracket surroundings
   "jiangmiao/auto-pairs" ,
   {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
    },

  -- Commenting
   "b3nj5m1n/kommentary" ,


  -- "Hop" navigation
   "phaazon/hop.nvim" ,

  -- Camelcase Movement
   "chaoren/vim-wordmotion" ,
   "bkad/CamelCaseMotion" ,

  -- HTML Tag completion
  -- https://docs.emmet.io/abbreviations/syntax/
   "mattn/emmet-vim" ,

  -- Autocompletion plugin
   "hrsh7th/cmp-nvim-lsp" ,
   "hrsh7th/cmp-buffer" ,
   "hrsh7th/cmp-path" ,
   "hrsh7th/cmp-cmdline" ,
   "hrsh7th/nvim-cmp" ,
   "f3fora/cmp-spell" ,
   "ray-x/cmp-treesitter" ,
   "hrsh7th/cmp-nvim-lua" ,
   "windwp/nvim-autopairs" ,

  -- VSCode Snippet Feature in Nvim
   "hrsh7th/cmp-vsnip" ,
   "hrsh7th/vim-vsnip" ,
   "onsails/lspkind-nvim" ,

  -- Formatter
   "mhartington/formatter.nvim" ,

  -- Telescope Finder
   "nvim-lua/plenary.nvim" ,
   "nvim-lua/popup.nvim" ,
   "nvim-telescope/telescope.nvim" ,
   "jvgrootveld/telescope-zoxide" ,

  -- Treesitter for NeoVim
   "nvim-treesitter/nvim-treesitter" }

  )


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
-- require("surround").setup({})

-- Copilot

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
-- Mason setup
require("mason").setup()

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

-- Copilot

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
opt.mouse =

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

map("n", "<leader>dp", "oimport pudb; pudb.set_trace()  # fmt: skip<Esc>")
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
    -- { name = "copilot" },
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
  --[[ sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,

      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  }, ]]
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
        -- Copilot = ""
      })[entry.source.name]

      return vim_item
    end,
  },
})

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup({
  mapping = {
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
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
