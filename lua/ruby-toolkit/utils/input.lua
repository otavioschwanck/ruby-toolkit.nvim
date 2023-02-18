local M = {}

function M.ask(question)
  return vim.fn.input(question)
end


function M.ask_not_null(question)
  local res = ""
  local count = 0

  while res == "" do
    if count > 0 then
      res = vim.fn.input(question .. " (Please inform something or press C-c to cancel) > ")
    else
      res = vim.fn.input(question)
    end

    count = count + 1
  end

  return res
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
