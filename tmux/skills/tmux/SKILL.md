---
name: tmux
description: This skill should be used when working with tmux terminal multiplexer for session management, window navigation, pane control, or creating tmux-based workflows for reviewing multiple files. Use when users need help with tmux commands, keybindings, session/window/pane operations, or custom tmux configurations.
---

# tmux Terminal Multiplexer Skill

This skill provides guidance for working with tmux, a terminal multiplexer that enables multiple terminal sessions, windows, and panes within a single terminal window.

## When to Use This Skill

Use this skill when:
- Creating or managing tmux sessions, windows, or panes
- Configuring tmux keybindings or settings in `~/.tmux.conf`
- Building workflows that leverage tmux for multi-file review or parallel tasks
- Troubleshooting tmux configuration issues
- Setting up custom tmux-based tools or functions

## User's tmux Configuration

The user has a custom tmux configuration at `~/.tmux.conf` with ergonomic keybindings optimized for file review workflows.

### Custom Keybindings

**Easy Window Navigation:**
- `Option+]` or `Ctrl+Shift+]` - Next window
- `Option+[` or `Ctrl+Shift+[` - Previous window
- `Option+{` - Move current window left
- `Option+}` - Move current window right

**Direct Window Jumping:**
- `Option+0` through `Option+9` - Jump directly to window 0-9

**Pane Switching:**
- `Option+Left/Right/Up/Down` - Navigate between panes

**Synchronization:**
- `Ctrl-b e` - Toggle pane synchronization (send commands to all panes)

**Standard tmux Keys (still available):**
- `Ctrl-b n` - Next window
- `Ctrl-b p` - Previous window
- `Ctrl-b w` - List all windows (visual selector)
- `Ctrl-b d` - Detach from session
- `Ctrl-b c` - Create new window
- `Ctrl-b ,` - Rename current window
- `Ctrl-b &` - Kill current window
- `Ctrl-b x` - Kill current pane
- `Ctrl-b "` - Split pane horizontally
- `Ctrl-b %` - Split pane vertically

### Configuration Features

The user's `~/.tmux.conf` includes:

```bash
# Mouse support enabled for scrolling and pane selection
set -g mouse on

# Pane border status showing index and running command
set -g pane-border-status top
set -g pane-border-format " #{pane_index} #{pane_current_command} "
```

## Custom tmux Workflows

### tmux-review Function

The user has a custom `tmux-review` shell function in `~/.zsh/claude-managed.zshrc` for reviewing multiple files with `glow` markdown rendering.

**Usage:**
```bash
tmux-review file1.md file2.sh file3.txt [... more files]
```

**Features:**
- Opens each file in a separate tmux window using `glow` for rendering
- Creates a helper window (window 0) with navigation instructions
- Generates unique session names with timestamps: `review-$(date +%s)`
- Validates all files exist before starting
- Helper text dynamically generated at `/tmp/tmux-review-helper.md`
- Window names use truncated filenames (max 20 chars)

**Example:**
```bash
# Review S3 bucket analysis files
tmux-review compliant-buckets.md non-compliant-buckets.md remediation.sh jira-update.md
```

This creates a tmux session with:
- Window 0: Helper text with navigation instructions
- Window 1: compliant-buckets.md (rendered with glow)
- Window 2: non-compliant-buckets.md (rendered with glow)
- Window 3: remediation.sh (rendered with glow)
- Window 4: jira-update.md (rendered with glow)

Navigate between files using `Option+]` / `Option+[` or `Ctrl+Shift+]` / `Ctrl+Shift+[`.

## Common tmux Operations

### Session Management

**Create new session:**
```bash
# Basic session
tmux new-session -s session-name

# Detached session (create without attaching)
tmux new-session -s session-name -d

# Named session with initial window name
tmux new-session -s session-name -n window-name
```

**List sessions:**
```bash
tmux list-sessions
# or
tmux ls
```

**Attach to session:**
```bash
tmux attach-session -t session-name
# or short form
tmux attach -t session-name
# or even shorter
tmux a -t session-name
```

**Detach from session:**
- Press `Ctrl-b d` inside tmux
- Session keeps running in background

**Kill session:**
```bash
tmux kill-session -t session-name
```

### Window Management

**Create new window:**
```bash
# Create window with name
tmux new-window -t session-name:window-number -n window-name

# Create window and run command
tmux new-window -t session-name:1 -n "logs" "tail -f /var/log/app.log"
```

**Send commands to window:**
```bash
# Send command and execute (C-m = Enter)
tmux send-keys -t session-name:window-number "command" C-m

# Example: Open file with glow in window 1
tmux send-keys -t myreview:1 "glow README.md" C-m
```

**Select window:**
```bash
tmux select-window -t session-name:window-number
```

**List windows:**
```bash
tmux list-windows -t session-name
```

**Swap windows:**
```bash
# Swap current window with next
tmux swap-window -t +1

# Swap current window with previous
tmux swap-window -t -1
```

### Pane Management

**Split pane horizontally:**
- `Ctrl-b "` (creates pane below)

**Split pane vertically:**
- `Ctrl-b %` (creates pane to the right)

**Navigate panes:**
- Use `Option+Arrow` keys (user's custom config)
- Or `Ctrl-b` followed by arrow keys

**Resize panes:**
```bash
# From command mode (Ctrl-b :)
resize-pane -D 5  # Down by 5 lines
resize-pane -U 5  # Up by 5 lines
resize-pane -L 5  # Left by 5 columns
resize-pane -R 5  # Right by 5 columns
```

**Synchronize panes:**
- Press `Ctrl-b e` to toggle (user's custom binding)
- All panes receive the same input when synchronized
- Useful for running commands on multiple servers

**Kill pane:**
- `Ctrl-b x` then confirm with `y`

## Configuration Management

### Reload Configuration

After editing `~/.tmux.conf`, reload it without restarting tmux:

**From shell:**
```bash
tmux source-file ~/.tmux.conf
```

**From within tmux:**
Press `Ctrl-b :` then type:
```
source-file ~/.tmux.conf
```

### Adding New Keybindings

Keybinding syntax in `~/.tmux.conf`:

```bash
# Prefix-based binding (requires Ctrl-b first)
bind key-name command

# No-prefix binding (direct keypress)
bind -n key-name command

# Example prefix binding: Ctrl-b r to reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Example no-prefix: Option+h to split horizontally
bind -n M-h split-window -h
```

**Key notation:**
- `M-` prefix = Option/Alt key (e.g., `M-[` = Option+[)
- `C-` prefix = Control key (e.g., `C-b` = Ctrl+b)
- `S-` prefix = Shift key (e.g., `C-S-[` = Ctrl+Shift+[)
- Special keys: `Left`, `Right`, `Up`, `Down`, `Enter`, etc.
- Brackets need quoting: `bind -n "C-S-[" previous-window`

**Common binding patterns:**

```bash
# Window navigation
bind -n M-] next-window
bind -n M-[ previous-window

# Pane navigation
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R

# Window jumping
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2

# Toggle feature
bind e setw synchronize-panes
```

### Common Configuration Options

```bash
# Enable mouse support (scroll, select panes, resize)
set -g mouse on

# Set default shell
set -g default-shell /bin/zsh

# Set scrollback buffer size
set -g history-limit 10000

# Start window numbering at 1 instead of 0
set -g base-index 1

# Start pane numbering at 1 instead of 0
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Set status bar position
set -g status-position top  # or bottom

# Status bar styling
set -g status-bg black
set -g status-fg white
set -g status-left '[#S] '
set -g status-right '%H:%M %d-%b-%y'

# Pane border styling
set -g pane-border-status top
set -g pane-border-format " #{pane_index} #{pane_current_command} "
set -g pane-border-style fg=colour240
set -g pane-active-border-style fg=colour33
```

## Creating tmux-Based Workflows

When building custom tmux workflows (like `tmux-review`), follow this pattern:

**1. Create session with descriptive name:**
```bash
tmux new-session -s "workflow-name" -d
```

**2. Create windows for each task:**
```bash
tmux new-window -t workflow-name:1 -n "window-name"
```

**3. Send commands to windows:**
```bash
tmux send-keys -t workflow-name:1 "command" C-m
```

**4. Select starting window:**
```bash
tmux select-window -t workflow-name:0
```

**5. Attach to session:**
```bash
tmux attach-session -t workflow-name
```

**Complete example workflow:**
```bash
# Create a code review session
review_code() {
  local session="code-review-$(date +%s)"

  # Create session with helper window
  tmux new-session -s "$session" -d -n "helper"
  tmux send-keys -t "$session:0" "cat review-checklist.md" C-m

  # Window 1: Main code
  tmux new-window -t "$session:1" -n "main"
  tmux send-keys -t "$session:1" "vim src/main.py" C-m

  # Window 2: Tests
  tmux new-window -t "$session:2" -n "tests"
  tmux send-keys -t "$session:2" "vim tests/test_main.py" C-m

  # Window 3: Run tests
  tmux new-window -t "$session:3" -n "pytest"
  tmux send-keys -t "$session:3" "pytest -v" C-m

  # Start at helper window
  tmux select-window -t "$session:0"
  tmux attach-session -t "$session"
}
```

## Troubleshooting

### Syntax Errors in Configuration

Common issues:

**Escaped semicolons:** Use space before `\;` in command chains
```bash
# Correct
bind r source-file ~/.tmux.conf \; display "Reloaded"

# Incorrect
bind r source-file ~/.tmux.conf\; display "Reloaded"
```

**Special characters in keybindings:** Quote brackets and special chars
```bash
# Correct
bind -n "C-S-[" previous-window

# May fail
bind -n C-S-[ previous-window
```

**Invalid key names:** Check tmux version compatibility
```bash
tmux -V  # Check version
```

### Session Not Found

If `tmux attach` fails:
```bash
# List all sessions to find correct name
tmux ls

# Create new session if none exists
tmux new-session -s session-name
```

### Configuration Not Loading

Verify configuration file exists:
```bash
ls -la ~/.tmux.conf
```

Check for syntax errors:
```bash
# This will show syntax errors if any exist
tmux source-file ~/.tmux.conf
```

View current tmux configuration:
```bash
# Show all current settings
tmux show-options -g

# Show all current keybindings
tmux list-keys
```

### Keybindings Not Working

Check if keybinding conflicts with terminal emulator:
- Some terminals intercept `Ctrl+Shift+[` before tmux sees it
- Test with `Option+[` alternative
- Use `tmux list-keys` to verify bindings are registered

Check if you're in a nested tmux session:
```bash
# From inside tmux
echo $TMUX
# If this shows a value, you're in tmux
```

## Self-Test

To verify this skill is working correctly:

1. **Check tmux installation and version:**
   ```bash
   tmux -V
   ```
   Expected: `tmux 3.5a` or similar

2. **Verify user's configuration exists:**
   ```bash
   cat ~/.tmux.conf
   ```
   Expected: Should show custom keybindings

3. **Test the `tmux-review` function exists:**
   ```bash
   type tmux-review
   ```
   Expected: Should show function definition

4. **Create and test a session:**
   ```bash
   tmux new-session -s test -d
   tmux ls | grep test
   tmux kill-session -t test
   ```
   Expected: Session appears in list, then is removed

All commands should execute without errors.
