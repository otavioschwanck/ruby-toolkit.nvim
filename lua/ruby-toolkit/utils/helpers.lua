local M = {}

local tree_sitter_select = require("nvim-treesitter.textobjects.select")
local tree_sitter_move = require("nvim-treesitter.textobjects.move")
local input = require("ruby-toolkit.utils.input")
local ask_y_or_n = input.ask_y_or_n

function M.term_codes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.insert_private_or_next(no_body)
  local private = M.private_line()

  vim.cmd("normal! m'")

  if private and private > vim.api.nvim__buf_stats(0).current_lnum then
    local put_after_private = ask_y_or_n("private found on this file.  Put function after private? > ")

    if put_after_private then
      vim.cmd("" .. private)

      M.paste_function(no_body)
    else
      M.go_to_end_of_function()

      M.paste_function(no_body)
    end
  else
    M.go_to_end_of_function()

    M.paste_function(no_body)
  end
end

function M.paste_function(no_body)
  vim.cmd("norm o")
  vim.cmd("norm odef ")
  vim.api.nvim_feedkeys("\"gp", "x", true)
  vim.cmd("norm oend")
  vim.cmd("norm k")

  if no_body then
    -- do nothing
  elseif string.sub(vim.fn.getreg("p"), -1, -1) == "\n" then
    vim.api.nvim_feedkeys("\"pp", "x", true)
  else
    vim.cmd("norm o")
    vim.api.nvim_feedkeys("\"pp", "x", true)
  end

  if not(no_body) then
    M.select_method()

    vim.api.nvim_feedkeys("=", "x", true)
  end
end

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
