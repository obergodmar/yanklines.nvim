# yanklines.nvim
This plugin provides a convenient way of copying search matches in nvim.

[Screencast_20231005_205240-1.webm](https://github.com/obergodmar/yanklines.nvim/assets/33424304/0e828fd5-8721-4c90-a3da-af8d778fd9d4)

## Installation

Lazy:
```lua
return {
  'obergodmar/yanklines.nvim',
  keys = {
    {
      '<leader>Y',
      function()
        require('yanklines').yank_lines()
      end,
      desc = '[Y]ank matched text',
      mode = { 'n' },
      id = 'yanklines',
    },
  },
}
```

Modify command `require('yanklines').yank_lines()` as you want, assign it to different shortcut or use `yank_lines` in another plugin/function.

## Description

The plugin basically does three things:
1) It looks for a last search pattern made
2) Finds highlighted (matched) text invoked by vim and copies it to vim reg
3) Writes the content from reg to system clipboard

Every point could be done with just vim commands without this plugin. But with this plugin makes it is easier and you don't need to memorize how to write to reg via command line every time when you need to copy all search matches you have in an opened buffer.

## V-Block Mode

Also it is possible to copy matched text only in visually selected region in vim's **v-block** mode. To do so add another shortcut or call the function `yank_lines` with an options arg and set `v_mode` which means **v-block** mode to true.

Example:

```lua
keys = {
  {
    '<leader>Y',
    function()
      require('yanklines').yank_lines()
    end,
    desc = '[Y]ank matched text',
    mode = { 'n' },
    id = 'yanklines',
  },
  {
    '<leader>Y',
    function()
      require('yanklines').yank_lines({ v_mode = true })
    end,
    desc = '[Y]ank matched text',
    mode = { 'v' },
    id = 'yanklines_v_block',
  },
}
```

## Options

To control which neovim registers the plugin should use you could pass options arg to a `yank_lines` function.
`opts { v_mode: boolean?, reg_read_to: string?, reg_write_to: string? }`

`v_mode` - execute the fn in V-Block neovim mode
`reg_read_to` - register name to read to data from matched text. Default is 'a'.
`reg_write_to` - register name to write to data. Default is '+y' which is the system clipboard.

