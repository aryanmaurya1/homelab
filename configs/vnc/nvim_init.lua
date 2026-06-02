-- VSCode-like Neovim config (copy to ~/.config/nvim/init.lua)

-- Bootstrap vim-plug
local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  vim.fn.system({
    "curl", "-fLo", plug_path, "--create-dirs",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  })
end

-- Options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.guicursor = "a:block"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- Plugins (vim-plug syntax)
vim.cmd([[
call plug#begin(stdpath('data') . '/site/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lewis6991/gitsigns.nvim'

call plug#end()
]])

-- Colorscheme
local ok, _ = pcall(function()
  vim.g.nord_contrast = true
  vim.g.nord_bold = true
  vim.g.nord_italic = true
  vim.cmd("colorscheme nord")
end)

-- Plugin setups (pcall'd in case plugins aren't installed yet)
pcall(function()
  require("nvim-tree").setup {
    sort_by = "case_sensitive",
    view = { width = 30 },
    renderer = { indent_markers = { enable = true } },
    actions = { open_file = { window_picker = { enable = false } } },
  }
end)

pcall(function()
  require("bufferline").setup {
    options = {
      mode = "buffers",
      separator_style = "thin",
      always_show_bufferline = true,
    },
  }
end)

pcall(function()
  require("lualine").setup {
    options = {
      theme = "nord",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_x = {
        { function() return os.date "%I:%M %p" end },
        "filetype",
      },
    },
  }
end)

pcall(function() require("Comment").setup() end)
pcall(function() require("gitsigns").setup() end)
pcall(function()
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    },
  }
end)

-- VSCode-like keybindings

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
map("n", "<C-s>", "<cmd>w<CR>", opts)                 -- Save
map("i", "<C-s>", "<cmd>w<CR>", opts)                 -- Save (insert)
map("n", "<C-q>", "<cmd>qa<CR>", opts)                -- Quit all
map("n", "<C-z>", "u", opts)                          -- Undo
map("i", "<C-z>", "<cmd>u<CR>", opts)                 -- Undo (insert)
map("n", "<C-y>", "<C-r>", opts)                      -- Redo
map("i", "<C-y>", "<cmd>redo<CR>", opts)              -- Redo (insert)
map("n", "<C-a>", "ggVG", opts)                       -- Select all

-- File explorer
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)    -- Toggle sidebar
map("i", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)    -- Toggle sidebar (insert)
map("v", "<C-b>", "<cmd>NvimTreeToggle<CR>", opts)    -- Toggle sidebar (visual)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts) -- Alt: Space+e
map("n", "<C-\\>", "<cmd>NvimTreeFocus<CR>", opts)    -- Focus sidebar

-- Fuzzy finder (Ctrl+P like VSCode)
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
map("n", "<C-S-p>", "<cmd>Telescope commands<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)

-- Buffer/tab management (like VSCode tabs)
map("n", "<C-w>", "<cmd>bd<CR>", opts)                    -- Close buffer
map("n", "<C-tab>", "<cmd>bn<CR>", opts)                  -- Next buffer
map("n", "<S-tab>", "<cmd>bp<CR>", opts)                  -- Previous buffer
map("n", "<C-n>", "<cmd>enew<CR>", opts)                  -- New file
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", opts)

-- Line operations (Alt+Up/Down in VSCode)
map("n", "<A-j>", "<cmd>m .+1<CR>==", opts)              -- Move line down
map("n", "<A-k>", "<cmd>m .-2<CR>==", opts)              -- Move line up
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", opts)       -- Move line down (insert)
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", opts)       -- Move line up (insert)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)              -- Move selection down
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)              -- Move selection up

-- Duplicate line (Shift+Alt+Down in VSCode)
map("n", "<A-S-j>", "<cmd>t.<CR>", opts)                 -- Duplicate down
map("i", "<A-S-j>", "<Esc><cmd>t.<CR>gi", opts)          -- Duplicate down (insert)

-- Comment (Ctrl+/)
map("n", "<C-/>", "gcc", { remap = true })
map("i", "<C-/>", "<Esc>gccgi", { remap = true })
map("v", "<C-/>", "gc", { remap = true })

-- Split management
map("n", "<leader>v", "<cmd>vsplit<CR>", opts)           -- Vertical split
map("n", "<leader>h", "<cmd>split<CR>", opts)            -- Horizontal split
map("n", "<leader>wd", "<cmd>close<CR>", opts)           -- Close pane

-- Window navigation with Ctrl+arrows
map("n", "<C-left>", "<cmd>wincmd h<CR>", opts)
map("n", "<C-down>", "<cmd>wincmd j<CR>", opts)
map("n", "<C-up>", "<cmd>wincmd k<CR>", opts)
map("n", "<C-right>", "<cmd>wincmd l<CR>", opts)

-- Search
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<C-h>", "<cmd>%s/", opts)                      -- Find and replace

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})
