vim.cmd [[packadd galaxyline.nvim]]

local gl = require("galaxyline")
local gls = gl.section
gl.short_line_list = {"LuaTree", "vista", "dbui"}

local colors = {
  fg = "#ABB2BF",
  bg = "#1E1E1E",

  red = "#D16969",
  error_red = "#F44747",
  green = "#608B4E",
  light_green = "#B5CEA8",
  yellow = "#DCDCAA",
  dark_yellow = "#D7BA7D",
  orange = "#CE9178",
  blue = "#569CD6",
  light_blue = "#9CDCFE",
  dark_blue = "#192e40",
  vivid_blue = "#4FC1FF",
  purple = "#C586C0",
  dark_purple = "#3b2839",
  cyan = "#4EC9B0",
  white = "#ABB2BF",
  black = "#1E1E1E",
  line_grey = "#5C6370",
  gutter_fg_grey = "#4B5263",
  cursor_grey = "#2C323C",
  visual_grey = "#3E4452",
  menu_grey = "#282C34",
  special_grey = "#3B4048",
  vertsplit = "#181A1F"
}

local empty_buffer = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  FirstElement = {
    provider = function()
      return "▋"
    end,
    highlight = {colors.blue, colors.blue}
  }
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {n = "NORMAL", i = "INSERT", c = "COMMAND", V = "VISUAL", [""] = "VISUAL"}
      return alias[vim.fn.mode()]
    end,
    separator = " ",
    separator_highlight = {
      colors.blue,
      function()
        if not empty_buffer() then
          return colors.blue
        end
        return colors.dark_blue
      end
    },
    highlight = {colors.bg, colors.blue, "bold"}
  }
}
gls.left[3] = {
  FileIcon = {
    provider = "FileIcon",
    condition = empty_buffer,
    highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.dark_blue}
  }
}
gls.left[4] = {
  FileName = {
    provider = {"FileName"},
    condition = empty_buffer,
    separator = "",
    separator_highlight = {colors.dark_purple, colors.dark_blue},
    highlight = {colors.purple, colors.dark_blue}
  }
}
gls.left[5] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = empty_buffer,
    highlight = {colors.orange, colors.dark_purple}
  }
}
gls.left[6] = {
  GitBranch = {
    provider = "GitBranch",
    condition = empty_buffer,
    highlight = {colors.grey, colors.dark_purple}
  }
}

local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

gls.left[7] = {
  DiffAdd = {
    provider = "DiffAdd",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.green, colors.dark_purple}
  }
}
gls.left[8] = {
  DiffModified = {
    provider = "DiffModified",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.orange, colors.dark_purple}
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.red, colors.dark_purple}
  }
}
gls.left[10] = {
  LeftEnd = {
    provider = function()
      return ""
    end,
    separator = "",
    separator_highlight = {colors.dark_purple, colors.bg},
    highlight = {colors.dark_purple, colors.dark_purple}
  }
}
gls.left[11] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors.red, colors.bg}
  }
}
gls.left[12] = {
  Space = {
    provider = function()
      return " "
    end
  }
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors.blue, colors.bg}
  }
}
gls.right[1] = {
  FileFormat = {
    provider = "FileFormat",
    separator = "",
    separator_highlight = {colors.bg, colors.dark_purple},
    highlight = {colors.grey, colors.dark_purple}
  }
}
gls.right[2] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " | ",
    separator_highlight = {colors.dark_blue, colors.dark_purple},
    highlight = {colors.grey, colors.dark_purple}
  }
}
gls.right[3] = {
  PerCent = {
    provider = "LinePercent",
    separator = "",
    separator_highlight = {colors.dark_blue, colors.dark_purple},
    highlight = {colors.grey, colors.dark_blue}
  }
}
gls.right[4] = {
  ScrollBar = {provider = "ScrollBar", highlight = {colors.yellow, colors.dark_purple}}
}

gls.short_line_left[1] = {
  BufferType = {
    provider = "FileTypeName",
    separator = "",
    separator_highlight = {colors.dark_purple, colors.bg},
    highlight = {colors.grey, colors.dark_purple}
  }
}
gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
    separator = "",
    separator_highlight = {colors.dark_purple, colors.bg},
    highlight = {colors.grey, colors.dark_purple}
  }
}
