<!--toc:start-->
- [Ruby Toolkit](#ruby-toolkit)
- [Demo](#demo)
  - [Extract Function](#extract-function)
- [Dependencies](#dependencies)
- [Installation](#installation)
  - [Packer](#packer)
- [Roadmap](#roadmap)
<!--toc:end-->

# Ruby Toolkit

Refactoring tools for Ruby and Ruby on rails.

# Demo

## Extract Function
![extract-function](https://i.imgur.com/FQUklWt.gif)

## Create function from word
![create-function](https://i.imgur.com/m02E22a.gif)

## Extract Variable
![extract-variable](https://i.imgur.com/cGtwqxo.gif)


# Dependencies

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) 

# Installation

## Packer

```lua
{ 'otavioschwanck/ruby-toolkit.nvim', requires = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" }, config = function()
  vim.keymap.set("n", "<leader>mv", "<cmd>lua require('ruby-toolkit').extract_variable()<CR>")
  vim.keymap.set("v", "<leader>mf", "<cmd>lua require('ruby-toolkit').extract_to_function()<CR>")
  vim.keymap.set("n", "<leader>mf", "<cmd>lua require('ruby-toolkit').create_function_from_text()<CR>")
end}

## Lazy

```lua
  { 'otavioschwanck/ruby-toolkit.nvim', dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" }, keys = {
    { "<leader>mv", "<cmd>lua require('ruby-toolkit').extract_variable()<CR>", desc = "Extract Variable", mode = { "v" } },
    { "<leader>mf", "<cmd>lua require('ruby-toolkit').extract_to_function()<CR>", desc = "Extract To Function", mode = { "v" } },
    { "<leader>mf", "<cmd>lua require('ruby-toolkit').create_function_from_text()<CR>", desc = "Create Function from item on cursor" },
  } },
```

# Roadmap

[ ] - Telescope rails routes / insert routes / go to route controller.
[ ] - Rails i18n search / insert.
