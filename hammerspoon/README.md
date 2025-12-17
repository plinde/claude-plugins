# Hammerspoon Plugin

Automate macOS with Hammerspoon Lua scripting. Window management, hotkeys, Spoons, and CLI integration.

## Features

- **Window Management** - Configure tiling hotkeys with ShiftIt Spoon
- **Hotkey Binding** - Create custom keyboard shortcuts
- **Spoons** - Load and configure Hammerspoon plugins
- **CLI Integration** - Use `hs` command for scripting and reloading
- **Configuration** - Manage `~/.hammerspoon/init.lua`

## Installation

```bash
claude plugin install hammerspoon@plinde-plugins
```

## Usage

The skill activates automatically when:
- Working with `~/.hammerspoon/` configuration
- Writing Lua code for macOS automation
- Configuring window management hotkeys
- Using the `hs` CLI command

## Quick Reference

### Enable CLI Support

Add to `~/.hammerspoon/init.lua`:

```lua
require("hs.ipc")
```

Then reload manually via menubar.

### Reload from CLI

```bash
hs -c 'hs.reload()'
```

### ShiftIt Window Hotkeys

```lua
hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({
    left = { { 'ctrl', 'cmd' }, 'left' },
    right = { { 'ctrl', 'cmd' }, 'right' },
    maximum = { { 'ctrl', 'cmd' }, 'm' },
})
```

## Requirements

- macOS
- [Hammerspoon](https://www.hammerspoon.org/) installed

## License

MIT License

## Author

Peter Linde
