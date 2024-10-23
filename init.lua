-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup mapleader before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Habilitar el mouse
vim.opt.mouse = "a"
-- Configuraciones varias
vim.opt.number = true

-- Configuración global (para todos los archivos)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- wrap lineas descativado
vim.opt.wrap = false

-- Autocomando para archivos HTML
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end,
})

vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Remapeos para NERDTree
-- Cambiar a la pestaña anterior usando '<C-S-h>'
vim.api.nvim_set_keymap('n', '<S-h>', '<C-w>h', { noremap = true, silent = true })

-- Cambiar a la pestaña siguiente usando '<C-S-l>'
vim.api.nvim_set_keymap('n', '<S-l>', '<C-w>l', { noremap = true, silent = true })

--Cambiar espacio de trabajo arriva
vim.api.nvim_set_keymap('n', '<S-k>', '<C-w>k', { noremap = true, silent = true })

--Cambiar espacio de trabajo abajo 
vim.api.nvim_set_keymap('n', '<S-j>', '<C-w>j', { noremap = true, silent = true })


-- Hacer mas grande
vim.api.nvim_set_keymap('n', '<S-Up>', '<C-w>>', { noremap = true, silent = true })

-- Hacer menor
vim.api.nvim_set_keymap('n', '<S-Down>', '<C-w><', { noremap = true, silent = true })


-- Key mappings in insert mode
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'KJ', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'kJ', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'Kj', '<Esc>', { noremap = true, silent = true })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Add your plugins here
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
},
    {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
},
      {
        'ellisonleao/gruvbox.nvim',
        priority = 1000, -- Asegúrate de que sea cargado primero si es tu esquema de colores principal
        config = function()
            -- Aplica el tema gruvbox
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },
  },

  -- Configure any other settings here
  install = { colorscheme = { "habamax" } },
  -- Automatically check for plugin updates
  checker = { enabled = true },
})
  -- Configuracion de lualine, es la barra de estado de neovim
require('lualine').setup({
	  options = {
		  theme = 'gruvbox',
		  section_separators = { left = '', right = '' },
		  component_separators = { left = '', right = '' },
		  disabled_filetypes = {
			  statusline = {},
			  winbar = {},
		  },
		  ignore_focus = {},
		  always_divide_middle = true,
		  globalstatus = true,
		  refresh = {
			  statusline = 1000,
			  tabline = 1000,
			  winbar = 1000,
		  }
	  },
  })


  -- Configuracion de treesitter
  require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


