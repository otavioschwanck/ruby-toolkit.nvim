local M = {}

local input = require("ruby-toolkit.utils.input")
local ask = input.ask
local ask_y_or_n = input.ask_y_or_n
local helpers = require("ruby-toolkit.utils.helpers")
local private_line = helpers.private_line
local indent_cur_line = helpers.indent_cur_line
local select_method = helpers.select_method
local go_to_end_of_function = helpers.go_to_end_of_function

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
        go_to_end_of_function()

        M.paste_function()
      end
    else
      go_to_end_of_function()

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
