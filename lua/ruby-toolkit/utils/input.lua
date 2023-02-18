local M = {}

function M.ask(question)
  return vim.fn.input(question)
end

function M.ask_y_or_n(question)
  print(question .. " (y/n) > ")

  local key = vim.fn.getcharstr()

  while key ~= "y" and key ~= "n" and key ~= "Y" and key ~= "N" do
    print(question .. ". Please, use y or n > ")

    key = vim.fn.getcharstr()
  end

  if key == "y" or key == "Y" then
    return true
  else
    return false
  end
end

return M
