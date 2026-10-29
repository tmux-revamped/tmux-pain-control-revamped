<div align="center">

# tmux-pain-control-revamped

<strong>Pane and window management bindings for tmux, version aware, vim friendly, every prefix key can be disabled.</strong>

English | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | [繁體中文（香港）](README.zh-HK.md)

[![family](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/family.yml?branch=main&style=flat-square&label=family)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/family.yml)
[![tests](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/tests.yml?branch=main&style=flat-square&label=tests)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/tests.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#what-it-does">What it does</a> |
  <a href="#installation">Installation</a> |
  <a href="#usage">Usage</a> |
  <a href="#configuration">Configuration</a> |
  <a href="#key-bindings">Key bindings</a> |
  <a href="#how-it-works">How it works</a>
</p>

</div>

**27** prefix keys bound by default, **12** more opt-in, **28** options, tmux **3.2** or later.

---

## What it does

The plugin binds pane navigation, resizing, splits that keep the current directory, and pane and window movement. It is a rewrite of [tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control) with more actions, and it replaces some of tmux's own keys on purpose.

| Capability | Option |
|:-----------|:-------|
| Splits and new windows open in the current pane's directory, `"` and `%` included | `@new_window_path` for `c` |
| Resize by a set number of cells | `@pane_resize` |
| Split along the longer side of the pane | `@pane_control_smart_split_key` |
| Join, break out, swap, promote and mark panes | `@pane_control_join_key` and the other pane keys |
| Prefixless `Ctrl+h/j/k/l` that moves between vim splits and tmux panes | `@pane_control_vim_navigation` |
| Stop pane selection at the window edge | `@pane_control_no_wrap` |
| Turn any listed key off | `@pane_control_disabled_keys` |

## Requirements

| Requirement | Version |
|:------------|:--------|
| tmux | 3.2 or later |
| bash | 3.2 or later |

It runs on Linux and macOS with BSD, GNU or uutils coreutils. Smart vim navigation uses `ps` and `grep` to detect vim in the pane.

## Installation

With [TPM](https://github.com/tmux-plugins/tpm), add the plugin to `~/.tmux.conf` and press `prefix + I`:

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

To install by hand, clone the repository and run the entrypoint from `~/.tmux.conf`:

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

## Usage

After installation, the keys in [Key bindings](#key-bindings) work after the prefix. `prefix + |` splits right and `prefix + -` splits down, both in the current directory. `prefix + h/j/k/l` moves between panes and `prefix + H/J/K/L` resizes them.

Turn on the opt-in actions you want, and switch off keys you need elsewhere:

```tmux
set -g @pane_control_sync_key 'S'
set -g @pane_control_swap_window_left_key '<'
set -g @pane_control_swap_window_right_key '>'
set -g @pane_control_scratch_key 'g'
set -g @pane_control_scratch_command 'htop'

set -g @pane_control_disabled_keys 'c, *'
set -g @pane_resize 10
```

To replace the tmux half of [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator):

```tmux
set -g @pane_control_vim_navigation 'on'
```

`Ctrl+h/j/k/l` then moves the vim split when vim has focus and the tmux pane otherwise, and `Ctrl+\` goes to the previous pane. Because this takes `Ctrl+l` without a prefix, `prefix + C-l` sends a clear-screen instead. The vim side still needs the vim-tmux-navigator plugin in your editor.

## Configuration

| Option | Default | Meaning |
|:-------|:--------|:--------|
| `@pane_resize` | `5` | Cells each resize key moves |
| `@new_window_path` | `true` | `true`, `on` or `1` binds `c` to open a new window in the current directory; any other value leaves `c` alone |
| `@pane_control_disabled_keys` | empty | Keys to leave unbound, separated by spaces or commas, such as `c, <` |
| `@pane_control_no_wrap` | `off` | `on` stops `h/j/k/l` selection at the window edge instead of wrapping |
| `@pane_control_pane_titles` | `off` | `on` shows the pane index and title in the top pane border |
| `@pane_control_vim_navigation` | `off` | `on` binds prefixless `Ctrl+h/j/k/l` and `Ctrl+\` with vim detection |
| `@pane_control_vim_pattern` | the vim-tmux-navigator pattern | Process name regex that marks a pane as running vim |
| `@pane_control_scratch_command` | empty | Command the scratch popup runs; empty opens your shell |
| `@pane_control_smart_split_key` | `*` | Smart split |
| `@pane_control_join_key` | `@` | Join a pane from another window, after a prompt |
| `@pane_control_break_key` | `!` | Break the current pane into its own window |
| `@pane_control_swap_prev_key` | `{` | Swap the pane with the previous one |
| `@pane_control_swap_next_key` | `}` | Swap the pane with the next one |
| `@pane_control_promote_key` | `+` | Swap the pane into the top-left slot |
| `@pane_control_mark_key` | `m` | Mark the pane |
| `@pane_control_swap_mark_key` | `=` | Swap the pane with the marked pane |
| `@pane_control_sync_key` | empty | Toggle `synchronize-panes` and show its state |
| `@pane_control_swap_window_left_key` | empty | Move the window one place left |
| `@pane_control_swap_window_right_key` | empty | Move the window one place right |
| `@pane_control_move_window_key` | empty | Move the window to another session, after a prompt |
| `@pane_control_kill_window_key` | empty | Kill the window, after a confirmation |
| `@pane_control_layout_even_h_key` | empty | `even-horizontal` layout |
| `@pane_control_layout_even_v_key` | empty | `even-vertical` layout |
| `@pane_control_layout_main_v_key` | empty | `main-vertical` layout |
| `@pane_control_respawn_key` | empty | Respawn the pane, after a confirmation |
| `@pane_control_capture_key` | empty | Save the whole scrollback to a file, after a prompt that offers `~/tmux-scrollback.log` |
| `@pane_control_pane_name_key` | empty | Set the pane title, after a prompt |
| `@pane_control_scratch_key` | empty | Open an 80% popup shell in the current directory |

A key option set to an empty value binds nothing. The plugin keeps no internal state options.

## Key bindings

### Bound by default

All of these follow the prefix. The navigation, resize, split and `c` keys cannot be moved, only disabled with `@pane_control_disabled_keys`.

| Key | Action | Repeatable |
|:----|:-------|:----------:|
| `h` `j` `k` `l`, `C-h` `C-j` `C-k` `C-l` | Select the pane left, below, above or right | No |
| `H` `J` `K` `L` | Resize the pane by `@pane_resize` cells | Yes |
| `\|` and `%` | Split right in the current directory | No |
| `-` and `"` | Split down in the current directory | No |
| `\` | Split at full window width | No |
| `_` | Split at full window height | No |
| `*` | Split along the longer side | No |
| `c` | New window in the current directory | No |
| `@` | Join a pane from another window | No |
| `!` | Break the pane into its own window | No |
| `{` `}` | Swap with the previous or next pane | Yes |
| `+` | Promote the pane to the top-left slot | No |
| `m` | Mark the pane | No |
| `=` | Swap with the marked pane | No |

`pain-control` is a declared overrider in the tmux-revamped family, so these keys replace stock tmux bindings by design.

### Opt-in

Version 2.0.0 unbound these. Set the option to the old key to restore one:

| Option | Old key | Action |
|:-------|:-------:|:-------|
| `@pane_control_sync_key` | `S` | Toggle synchronized panes |
| `@pane_control_swap_window_left_key` | `<` | Move the window left |
| `@pane_control_swap_window_right_key` | `>` | Move the window right |
| `@pane_control_move_window_key` | `.` | Move the window to a session |
| `@pane_control_kill_window_key` | `&` | Kill the window |
| `@pane_control_layout_even_h_key` | `E` | `even-horizontal` layout |
| `@pane_control_layout_even_v_key` | `V` | `even-vertical` layout |
| `@pane_control_layout_main_v_key` | `B` | `main-vertical` layout |
| `@pane_control_respawn_key` | `R` | Respawn the pane |
| `@pane_control_capture_key` | `C` | Capture the scrollback |
| `@pane_control_pane_name_key` | `P` | Name the pane |
| `@pane_control_scratch_key` | `g` | Scratch popup |

### Smart vim navigation

With `@pane_control_vim_navigation` set to `on`, the plugin also binds `C-h`, `C-j`, `C-k`, `C-l` and `C-\` in the root table and in `copy-mode-vi`, and rebinds `prefix + C-l` to clear the screen. `@pane_control_disabled_keys` does not apply to these.

## How it works

[`pain-control-revamped.tmux`](pain-control-revamped.tmux) runs [`src/pain.sh`](src/pain.sh) once when tmux loads the plugin. The script reads the options and the tmux version, then issues `bind-key` for each key. Nothing runs in the background afterwards.

Each binding carries a `-N` note, so `prefix + ?` lists it with a description. On tmux older than 3.2 the version checks in the script still drop what that tmux lacks: full splits need 2.3, marks 2.1, pane names and edge no-wrap 2.6, the `{top-left}` promote target 3.0, and the scratch popup 3.2.

With vim navigation on, each chord runs `ps` on the pane's TTY and matches the process name against `@pane_control_vim_pattern`. A match sends the key to vim; otherwise tmux selects the pane.

The version and key helpers live in [`src/lib/pain/pain.sh`](src/lib/pain/pain.sh). Setting `PAIN_DRY_RUN` makes the script print each tmux command instead of running it, which is how the test suite checks the bindings.

## Development

| Command | What it does |
|:--------|:-------------|
| `make test` | Runs the bats suite |
| `make lint` | Runs shellcheck on every shell file |
| `make coverage` | Measures line coverage with kcov on Linux and fails below 95% |

Changes are listed in [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE)

<!-- family:begin -->

## The tmux-revamped family

This plugin is one member of the tmux-revamped family. Every member carries the
same contract in [`FAMILY.md`](FAMILY.md), the same tooling under `family/`, and
the same shared library, all held byte-identical by a checksum manifest. They are
built to be installed together: no member claims a key or a tmux option that
another member claims.

A defect found in one member is hunted across all of them before the fix is
called done. That obligation is written into the contract rather than left to
memory, and `family/bin/sweep` is how it is discharged.

| Member | What it does |
|---|---|
| [`tmux-autoreload-revamped`](https://github.com/tmux-revamped/tmux-autoreload-revamped) | Edit your tmux config, save, and watch it reload itself, no key, no command |
| [`tmux-battery-revamped`](https://github.com/tmux-revamped/tmux-battery-revamped) | Battery status for your tmux status bar, without ever blocking the status render |
| [`tmux-bluetooth-revamped`](https://github.com/tmux-revamped/tmux-bluetooth-revamped) | Every connected Bluetooth device and its battery in your tmux status bar, without blocking the render |
| [`tmux-cpu-revamped`](https://github.com/tmux-revamped/tmux-cpu-revamped) | CPU load, temperature, and frequency in your tmux status bar, without ever blocking the render |
| [`tmux-disk-revamped`](https://github.com/tmux-revamped/tmux-disk-revamped) | Disk usage for your tmux status bar, without ever blocking the status render |
| [`tmux-extract-revamped`](https://github.com/tmux-revamped/tmux-extract-revamped) | Pick a URL, path, hash or any other token off the screen with fzf and type it at the cursor, in pure shell |
| [`tmux-fzf-revamped`](https://github.com/tmux-revamped/tmux-fzf-revamped) | Switch to, kill, rename or create tmux sessions, windows and panes from fzf pickers in a popup |
| [`tmux-git-revamped`](https://github.com/tmux-revamped/tmux-git-revamped) | Show the active pane's git branch, changes and provider counts in the tmux status bar without blocking it |
| [`tmux-gpu-revamped`](https://github.com/tmux-revamped/tmux-gpu-revamped) | GPU load, temperature, clock, power and memory in the tmux status bar, from NVIDIA, AMD, Intel and Apple GPUs |
| [`tmux-kube-revamped`](https://github.com/tmux-revamped/tmux-kube-revamped) | Current Kubernetes context and namespace in the tmux status bar, parsed from kubeconfig without kubectl |
| [`tmux-launcher-revamped`](https://github.com/tmux-revamped/tmux-launcher-revamped) | Launch any TUI app in a popup or a window, scoped to the current pane's directory, with one configurable bindi |
| [`tmux-logging-revamped`](https://github.com/tmux-revamped/tmux-logging-revamped) | Capture any pane to a file: live logging, full scrollback, or a one-shot screenshot |
| [`tmux-music-revamped`](https://github.com/tmux-revamped/tmux-music-revamped) | Now playing in your tmux status bar, without ever blocking the status render |
| [`tmux-network-revamped`](https://github.com/tmux-revamped/tmux-network-revamped) | Network throughput in your tmux status bar, without ever blocking the render |
| [`tmux-pain-control-revamped`](https://github.com/tmux-revamped/tmux-pain-control-revamped) | **this plugin**, Pane and window management bindings for tmux, version aware, vim friendly, every prefix key can be disabled |
| [`tmux-persist-revamped`](https://github.com/tmux-revamped/tmux-persist-revamped) | Save every tmux session, window and pane, auto-save on a timer, and restore it all after a reboot |
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | The starting point for a tmux-revamped plugin: shared library, bats harness, CI and family tooling |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | A Pomodoro timer in the tmux status bar that keeps all of its state in tmux options, with no temp files |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | RAM, swap and memory pressure in the tmux status bar, sampled in the background so the render never waits |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | Drag a window tab along the tmux status bar with the mouse to move that window |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | Send the mouse wheel to apps that scroll themselves and into tmux copy-mode everywhere else |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | Sensible tmux defaults, gated by tmux version and terminal, that leave the options you set alone |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | Tiling window management for tmux: eight layouts including BSP dwindle and spiral, with layout undo |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | Local and world clocks for the tmux status bar, colored by time of day, with countdowns and a DST warning |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | Weather for the tmux status bar from wttr.in, fetched in the background so the status line never waits |

### Checking an installation

With every member on disk, one command reports any conflict between them:

```sh
family/bin/doctor --live
```

It reads each member and the running tmux server, and reports duplicate keys,
duplicate status placeholders, options outside the naming grammar, and any
member whose contract version has fallen behind.

<!-- family:end -->
