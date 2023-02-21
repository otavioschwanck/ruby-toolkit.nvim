local M = {}

local input = require("ruby-toolkit.utils.input")
local ask = input.ask
local term_codes = require("ruby-toolkit.utils.helpers").term_codes

function M.extract_variable()
  local variable_name = ask("Variable name > ")

  if variable_name ~= "" then
    local current_g = vim.fn.getreg("g")
    local current_p = vim.fn.getreg("p")

    vim.fn.setreg("g", variable_name)

    vim.cmd("normal! m'")
    vim.fn.feedkeys(term_codes("\"pygv\"gp==O<C-r>g = <C-r>p<Esc>=="), "x")

    local _, count = string.gsub(vim.fn.getreg("p"), "\n", "")

    vim.api.nvim_feedkeys(count .. "k" .. (count + 1) .. "==", "x", true)

    vim.cmd(term_codes("normal! <C-o>"))

    vim.fn.setreg("g", current_g)
    vim.fn.setreg("p", current_p)
  end
end

return M
