vim.cmd [[packadd ale]]
local M = {}

function M.getCompletionItems(prefix)
  local items = vim.api.nvim_call_function("ale#completion#OmniFunc", {0, prefix})
  return items
end

M.complete_item = {item = M.getCompletionItems}

return M
