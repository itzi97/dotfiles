vim.cmd [[packadd vim-pandoc]]
local M = {}

function M.getCompletionItems(prefix)
  local items = vim.api.nvim_call_function("pandoc#completion#Complete", {0, prefix})
  return items
end

M.complete_item = {item = M.getCompletionItems}

return M
