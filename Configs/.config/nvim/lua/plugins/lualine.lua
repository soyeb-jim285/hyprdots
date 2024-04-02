local Util = require("lazyvim.util")
local lualine_require = require("lualine_require")
lualine_require.require = require

local icons = require("lazyvim.config").icons

local colors = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2d",
  mantle = "#181825",
  crust = "#11111b",
}

local my_catppucin = {
  normal = {
    a = { bg = colors.blue, fg = colors.crust, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.blue },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
  insert = {
    a = { bg = colors.teal, fg = colors.crust, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.teal },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
  visual = {
    a = { bg = colors.mauve, fg = colors.crust, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.mauve },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
  replace = {
    a = { bg = colors.red, fg = colors.crust, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.red },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
  command = {
    a = { bg = colors.peach, fg = colors.crust, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.peach },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
  inactive = {
    a = { bg = colors.surface0, fg = colors.text, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.text },
    c = { bg = colors.mantle, fg = colors.text, gui = "italic" },
    y = { bg = colors.red, fg = colors.crust },
    z = { bg = colors.rosewater, fg = colors.crust, gui = "bold" },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = my_catppucin,
        component_separators = { left = "｠", right = "｟" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
        lualine_b = { "branch" },

        lualine_c = {
          Util.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { Util.lualine.pretty_path() },
        },
        lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.ui.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.ui.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.ui.fg("Debug"),
            },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = Util.ui.fg("Special"),
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          { "location", separator = { left = "", right = "" }, left_padding = 2 },
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
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
    vim.o.laststatus = vim.g.lualine_laststatus
  end,
}
