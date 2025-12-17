# tmux Plugin

Work with tmux terminal multiplexer for session management, window navigation, pane control, and custom workflows.

## Features

- **Session Management** - Create, attach, detach, and kill tmux sessions
- **Window Navigation** - Navigate, create, rename, and swap windows
- **Pane Control** - Split, resize, and synchronize panes
- **Custom Keybindings** - Configure ergonomic keybindings in `~/.tmux.conf`
- **Workflow Automation** - Build custom tmux-based workflows like multi-file review

## Installation

```bash
claude plugin install tmux@plinde-plugins
```

## Usage

The skill activates automatically when:
- Working with tmux sessions, windows, or panes
- Configuring `~/.tmux.conf`
- Building tmux-based workflows
- Troubleshooting tmux configuration

## Quick Reference

### Session Commands

```bash
tmux new-session -s name     # Create session
tmux attach -t name          # Attach to session
tmux ls                      # List sessions
tmux kill-session -t name    # Kill session
```

### Common Keybindings

| Key | Action |
|-----|--------|
| `Ctrl-b c` | Create new window |
| `Ctrl-b n` | Next window |
| `Ctrl-b p` | Previous window |
| `Ctrl-b d` | Detach from session |
| `Ctrl-b "` | Split pane horizontally |
| `Ctrl-b %` | Split pane vertically |

## Requirements

- tmux installed (`brew install tmux` on macOS)

## License

MIT License

## Author

Peter Linde
