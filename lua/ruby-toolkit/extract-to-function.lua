local M = {}

local input = require("ruby-toolkit.utils.input")
local ask = input.ask
local helpers = require("ruby-toolkit.utils.helpers")
local insert_private_or_next = helpers.insert_private_or_next

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

    vim.fn.feedkeys("\"pygv\"gp==", "x")

    insert_private_or_next()

    print("Function extracted. Press <C-o> to go back to it.")
  end

  vim.fn.setreg("g", current_g)
  vim.fn.setreg("p", current_p)
end

-- private

vim.keymap.set("v", "<CR>", M.extract_to_function)

return M
