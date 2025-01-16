# 🎨 JB for Neovim

<p>Color scheme for Neovim, inspired by JetBrains IDEs.</p>

<table width="100%">
  <tr>
    <th>Dark</th>
    <th>Light</th>
  </tr>
  <tr>
    <td>
        <img width="512" alt="dark-js" src="https://github.com/user-attachments/assets/dcff0247-868e-4aa4-bac1-22729099fb46" />
    </td>
    <td>
        <img width="512" alt="light-js" src="https://github.com/user-attachments/assets/89863d62-5c69-45f3-b21e-9e8c17cc3281" />
    </td>
  </tr>
</table>

## Features

- Supports both light and dark themes
- Terminal colors.


<details>
<summary>Supported Languages</summary>

| Language      | Syntax | Treesitter                     | Semantic     |
|---------------|--------|--------------------------------|--------------|
| Blade         | n/a    | ✅ (EmranMR/tree-sitter-blade) | n/a          |
| C/C++         | ⚠️     | ✅ (c,cpp)                     | n/a          |
| CSS           | ⚠️     | ✅ (css)                       | n/a          |
| EditorConfig  | n/a    | ✅ (editorconfig)              | n/a          |
| HTML          | ⚠️     | ✅ (html)                      | n/a          |
| JavaScript    | ⚠️     | ✅ (javascript)                | ✅ (ts_ls)   |
| JSON          | ✅     | ✅ (json)                      | n/a          |
| Lua           | ⚠️     | ✅ (lua,luadoc)                | ✅ (lua_ls)  |
| Markdown      | ⚠️     | ✅ (markdown,markdown_inline)  | n/a          |
| Nix           | ⚠️     | ✅ (nix)                       | ✅ (nil_lsp) |
| PHP           | ⚠️     | ✅ (php,phpdoc)                | n/a          |
| Python        | ⚠️     | ✅ (python)                    | n/a          |
| RegExp        | ⚠️     | ✅ (regex)                     | n/a          |
| Sass/SCSS     | ⚠️     | ✅ (scss)                      | n/a          |
| Shell Script  | ⚠️     | ✅ (bash)                      | n/a          |
| Twig          | n/a    | ✅ (twig)                      | n/a          |
| TypeScript    | ⚠️     | ✅ (typescript)                | ✅ (ts_ls)   |

</details>


<details>
<summary>Supported Plugins</summary>

| Plugin                                                                          | Source |
|---------------------------------------------------------------------------------|--------|
| [copilot.vim](https://github.com/github/copilot.vim)                            | n/a    |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua)                                  | n/a    |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                     | n/a    |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | n/a    |
| [neogit](https://github.com/NeogitOrg/neogit)                                   | n/a    |
| [nvim-notify](https://github.com/rcarriga/nvim-notify)                          | n/a    |
| [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)                  | n/a    |
| [supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim)            | n/a    |

</details>

## Installation

Install the theme with your preferred package manager, such as
[folke/lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "nickkadutskyi/jb.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        -- require("jb").setup({transparent = true})
        vim.cmd("colorscheme jb")
    end,
}
```

### Usage

```lua
vim.cmd("colorscheme jb")
```

```vim
colorscheme jb
```

Change light/dark theme:

```lua
vim.o.background = "light"
```

```vim
set background=light
```

## Configuration

> [!IMPORTANT]
> Set the configuration **BEFORE** loading the color scheme `colorscheme jb`.

<details>
  <summary>Default Options</summary>

<!-- config:start -->

```lua

---@class jb.Config
M.defaults = {
    -- Enable this to remove background from Normal and NormalNC
    transparent = false,
}
```

<!-- config:end -->

</details>

## Overriding Colors & Highlight Groups

n/a

## Extras

n/a

## Contributing

n/a
