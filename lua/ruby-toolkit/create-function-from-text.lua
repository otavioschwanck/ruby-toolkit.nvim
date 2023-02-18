local M = {}

local input = require("ruby-toolkit.utils.input")
local helpers = require("ruby-toolkit.utils.helpers")
local ask_not_null = input.ask_not_null
local insert_private_or_next = helpers.insert_private_or_next

function M.create_function_from_text()
  local ts_utils = require('nvim-treesitter.ts_utils')

  local current_g = vim.fn.getreg("g")
  local current_p = vim.fn.getreg("p")

  local function_name = ts_utils.get_node_at_cursor()

  if(function_name:type() == "identifier") then
    local next_node = ts_utils.get_next_node(function_name)

    local children

    if next_node and next_node:type() == "argument_list" then
      children = ts_utils.get_named_children(next_node)
    end

    local normalized_arguments = {}

    if children then
      for i=1,#children do
        local arg = ts_utils.get_node_text(children[i])[1]

        if string.match(arg, "^%a+_*%a*$") then
          table.insert(normalized_arguments, arg)
        else
          local new_arg = ask_not_null("Please inform the argument name for: " .. arg .. " > ")

          table.insert(normalized_arguments, new_arg)
        end
      end
    end

    local full_function_name = ts_utils.get_node_text(function_name)[1]

    if #normalized_arguments then
      full_function_name = full_function_name .. "(" .. table.concat(normalized_arguments, ", ") .. ")"
    end

    vim.fn.setreg("g", full_function_name)
    vim.fn.setreg("p", "\n")

    insert_private_or_next(true)

    vim.fn.setreg("g", current_g)
    vim.fn.setreg("p", current_p)

    vim.cmd(helpers.term_codes('normal <C-o>'))

    print("Method created. Press <C-i> to go back to then.")
  else
    print("you are not in a function call.")
  end

end

vim.keymap.set("n", "<CR>", M.create_function_from_text)

return M
