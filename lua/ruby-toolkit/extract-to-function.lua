local M = {}

local tree_sitter_move = require("nvim-treesitter.textobjects.move")
local tree_sitter_select = require("nvim-treesitter.textobjects.select")
local input = require("ruby-toolkit.utils.input")
local ask = input.ask
local ask_y_or_n = input.ask_y_or_n

local function private_line()
  local buf_text = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for i = 1, #buf_text do
    if string.match(buf_text[i], "private$") then
      return i
    end
  end

  return false
end

local function indent_cur_line()
  vim.cmd("norm ==")
end

local function select_method()
  vim.api.nvim_feedkeys("V", "x", true)
  tree_sitter_select.select_textobject("@function.outer")
end

function M.extract_to_function()
  local function_name = ask("Function name > ")

  local current_g = vim.fn.getreg("g")
  local current_p = vim.fn.getreg("p")

  if function_name ~= "" then
    local arguments = ask("Arguments separated by comma > ")

    local full_function_name = function_name

    if arguments ~= "" then
      full_function_name = full_function_name .. "(" .. arguments .. ")"
    end

    vim.fn.setreg("g", full_function_name)

    vim.fn.feedkeys("\"pygv\"gp", "x")

    local private = private_line()

    indent_cur_line()

    vim.cmd("normal! m'")

    if private and private > vim.api.nvim__buf_stats(0).current_lnum then
      local put_after_private = ask_y_or_n("private found on this file.  Put function after private? > ")

      if put_after_private then
        vim.cmd("" .. private)

        M.paste_function()
      else
        tree_sitter_move.goto_next_end("@function.outer")

        M.paste_function()
      end
    else
      tree_sitter_move.goto_next_end("@function.outer")

      M.paste_function()
    end
  end

  vim.fn.setreg("g", current_g)
  vim.fn.setreg("p", current_p)
end

-- private

function M.paste_function()
  vim.cmd("norm o")
  vim.cmd("norm odef ")
  vim.api.nvim_feedkeys("\"gp", "x", true)
  vim.cmd("norm oend")
  vim.cmd("norm k")

  if string.sub(vim.fn.getreg("*"), -1, -1) == "\n" then
    vim.api.nvim_feedkeys("\"pp", "x", true)
  else
    vim.cmd("norm o")
    vim.api.nvim_feedkeys("\"pp", "x", true)
  end

  select_method()

  vim.api.nvim_feedkeys("=", "x", true)
end

vim.keymap.set('v', "<CR>", M.extract_to_function)

return M
