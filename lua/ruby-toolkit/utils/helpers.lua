local M = {}

local tree_sitter_select = require("nvim-treesitter.textobjects.select")
local tree_sitter_move = require("nvim-treesitter.textobjects.move")

function M.indent_cur_line()
  vim.cmd("norm ==")
end

function M.go_to_end_of_function()
  tree_sitter_move.goto_next_end("@function.outer")
end

function M.select_method()
  vim.api.nvim_feedkeys("V", "x", true)
  tree_sitter_select.select_textobject("@function.outer")
end

function M.private_line()
  local buf_text = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for i = 1, #buf_text do
    if string.match(buf_text[i], "private$") then
      return i
    end
  end

  return false
end


return M
