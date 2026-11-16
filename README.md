<div align="center">

# tmux-pain-control-revamped

<strong>Pane and window management bindings for tmux, version aware, vim friendly, every prefix key can be disabled.</strong>

English &nbsp;|&nbsp; [日本語](README.ja.md) &nbsp;|&nbsp; [简体中文](README.zh-Hans.md) &nbsp;|&nbsp; [繁體中文（香港）](README.zh-HK.md)

[![ci](https://img.shields.io/github/actions/workflow/status/tmux-revamped/tmux-pain-control-revamped/ci.yml?branch=main&style=flat-square&label=ci)](https://github.com/tmux-revamped/tmux-pain-control-revamped/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=release)](https://github.com/tmux-revamped/tmux-pain-control-revamped/releases/latest)
[![openssf scorecard](https://img.shields.io/ossf-scorecard/github.com/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=openssf%20scorecard)](https://scorecard.dev/viewer/?uri=github.com/tmux-revamped/tmux-pain-control-revamped)
[![license](https://img.shields.io/github/license/tmux-revamped/tmux-pain-control-revamped?style=flat-square&label=license)](LICENSE)

<p align="center">
  <a href="#quick-start"><strong>Quick start</strong></a> &nbsp;|&nbsp;
  <a href="#usage">Usage</a> &nbsp;|&nbsp;
  <a href="#keys">Keys</a> &nbsp;|&nbsp;
  <a href="#screens">Screens</a>
</p>

</div>

<p align="center">
  <img src="screens/hero.gif" alt="tmux splitting, moving between, resizing and promoting panes with the plugin's keys" width="800">
</p>

```console
$ pain-control-revamped list
bind-key -N Select pane left h select-pane -L
bind-key -N Select pane left C-h select-pane -L
bind-key -N Select pane below j select-pane -D
bind-key -N Select pane below C-j select-pane -D
```

Every key is checked against the tmux version, carries a note that `prefix ?` shows, and can be left alone. The keys go to tmux in one call when the plugin loads; nothing runs afterwards.

---

## Quick start

### Prerequisites

| Tool | Version | Used for |
|:-----|:--------|:---------|
| tmux | 3.2 or later | the family floor; older versions lose the keys they lack |
| `ps` | any | vim navigation, when it is on |
| gum | optional | the menu, tables and colours of `pain-control-revamped`; without it every command prints plain text |

### Install

```tmux
set -g @plugin 'tmux-revamped/tmux-pain-control-revamped'
```

Then press `prefix + I`. Without TPM, clone the repository and run its entry point from `~/.tmux.conf`:

```bash
git clone https://github.com/tmux-revamped/tmux-pain-control-revamped ~/.tmux/plugins/tmux-pain-control-revamped
```

```tmux
run-shell ~/.tmux/plugins/tmux-pain-control-revamped/pain-control-revamped.tmux
```

`make install` in the clone also puts `pain-control-revamped` in `~/.local/bin`, with its man page and completions under `~/.local/share`.

### Verify

```bash
~/.tmux/plugins/tmux-pain-control-revamped/bin/pain-control-revamped doctor
```

## Usage

| Command | What it does |
|:--------|:-------------|
| `pain-control-revamped apply` | Binds every key now; the entry point runs it when tmux loads the plugin |
| `pain-control-revamped list` | Prints every binding apply would make; `--json` prints one object |
| `pain-control-revamped zoom` | Moves the pane to a window of its own, leaving a placeholder in its place; run again in either, it puts the pane back |
| `pain-control-revamped doctor` | One row per dependency |
| `pain-control-revamped version` | The version, then the tmux version |
| `pain-control-revamped help` | The help page; `man pain-control-revamped` documents the same commands and settings |
| `pain-control-revamped` | On a terminal, a menu |

| tmux option | Default | Meaning |
|:------------|:--------|:--------|
| `@pain_control_revamped_resize` | `5` | Cells per resize step |
| `@pain_control_revamped_new_window_path` | `true` | `c` opens the new window in the pane's folder |
| `@pain_control_revamped_disabled_keys` | none | Keys to leave alone, separated by spaces or commas |
| `@pain_control_revamped_no_wrap` | `off` | `on` stops pane navigation at the window's edge |
| `@pain_control_revamped_vim_navigation` | `off` | `on` binds `C-h` to `C-l` and `C-\` without the prefix, sending them to vim when it runs in the pane, or to any pane whose `@pane-is-vim` option is set, as [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) sets it |
| `@pain_control_revamped_vim_pattern` | vim, nvim, view, fzf | The process names vim navigation treats as vim |
| `@pain_control_revamped_pane_titles` | `off` | `on` shows each pane's index and title on its border |
| `@pain_control_revamped_scratch_command` | a shell | What the scratch popup runs |
| `@pain_control_revamped_zoom_key` | none | The key that runs `zoom` |
| `@pain_control_revamped_focus_size` | none | A whole number from 50 to 99: the percent of the window's width and height the focused pane grows to after each pane selection and split. Unsetting it takes effect when the tmux server restarts |

Each key in the next section has its own option too, such as `@pain_control_revamped_join_key`. Every option is also a command option with dashes, such as `--join-key J`, and an environment variable, such as `PAIN_CONTROL_REVAMPED_JOIN_KEY`; the command line wins over the environment, and the environment over the tmux option. An empty tmux option means its default.

The options were named `@pane_control_*`, `@pane_resize` and `@new_window_path` before 3.0.0, and those names no longer work.

<a id="keys"></a>

## Keys

All of these follow the prefix. pain-control is a declared overrider in the tmux-revamped family, so they replace stock tmux keys by design.

| Key | Action | Option |
|:----|:-------|:-------|
| `h` `j` `k` `l`, `C-h` `C-j` `C-k` `C-l` | Select the pane left, below, above or right | none |
| `H` `J` `K` `L` | Resize the pane, repeatable | none |
| `\|` and `%`, `-` and `"` | Split right or down in the current folder | none |
| `\` and `_` | Split at full window width or height | none |
| `*` | Split along the longer side | `_smart_split_key` |
| `c` | New window in the current folder | `_new_window_path` |
| `@` | Join a pane from another window | `_join_key` |
| `!` | Break the pane into its own window | `_break_key` |
| `{` `}` | Swap with the previous or next pane, repeatable | `_swap_prev_key`, `_swap_next_key` |
| `+` | Promote the pane to the top-left slot | `_promote_key` |
| `m`, `=` | Mark the pane, swap with the marked pane | `_mark_key`, `_swap_mark_key` |

These have no key until their option sets one: `_sync_key` toggles synchronized panes, `_swap_window_left_key` and `_swap_window_right_key` move the window, `_move_window_key` moves it to a session, `_kill_window_key` kills it, `_layout_even_h_key`, `_layout_even_v_key` and `_layout_main_v_key` pick a layout, `_respawn_key` respawns the pane, `_capture_key` saves its scrollback, `_pane_name_key` names it, `_scratch_key` opens a scratch popup, and `_zoom_key` runs power zoom.

Version checks drop what an older tmux lacks: full splits need 2.3, marks 2.1, pane names and no-wrap 2.6, the `{top-left}` promote target 3.0, the scratch popup 3.2, power zoom 3.0, focus size 3.1, and the notes 3.1.

<a id="screens"></a>

## Screens

<details>
<summary>Every screen, recorded inside a real tmux with <code>make screens</code>, with each key on the status line</summary>
<br>

<table>
<tr>
<td width="50%" valign="top"><img src="screens/splits.png" alt="pain-control-revamped: Splits, navigation, resize, promote and smart split"><br><sub>Splits, navigation, resize, promote and smart split, from <code>hero.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/window.png" alt="pain-control-revamped: A new window in the current folder"><br><sub>A new window in the current folder, from <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/break.png" alt="pain-control-revamped: A pane broken into its own window"><br><sub>A pane broken into its own window, from <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/join.png" alt="pain-control-revamped: Joining a pane from another window"><br><sub>Joining a pane from another window, from <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/mark.png" alt="pain-control-revamped: Mark a pane and swap with it"><br><sub>Mark a pane and swap with it, from <code>keys.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/swap.png" alt="pain-control-revamped: Swap with the previous and next pane"><br><sub>Swap with the previous and next pane, from <code>keys.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/titles.png" alt="pain-control-revamped: Pane titles on the borders"><br><sub>Pane titles on the borders, from <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/sync.png" alt="pain-control-revamped: Synchronized panes"><br><sub>Synchronized panes, from <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/vim-nowrap.png" alt="pain-control-revamped: Vim navigation and no-wrap"><br><sub>Vim navigation and no-wrap, from <code>options.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/scratch-popup.png" alt="pain-control-revamped: The scratch popup"><br><sub>The scratch popup, from <code>options.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/list.png" alt="pain-control-revamped: list"><br><sub><code>list</code>, from <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/json.png" alt="pain-control-revamped: list --json"><br><sub><code>list --json</code>, from <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/doctor.png" alt="pain-control-revamped: doctor"><br><sub><code>doctor</code>, from <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/menu.png" alt="pain-control-revamped: The menu"><br><sub>The menu, from <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/plain-menu.png" alt="pain-control-revamped: The menu without gum"><br><sub>The menu without gum, from <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/plain-apply.png" alt="pain-control-revamped: apply from the menu"><br><sub><code>apply</code> from the menu, from <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/version.png" alt="pain-control-revamped: The version"><br><sub>The version, from <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/error.png" alt="pain-control-revamped: An unknown command"><br><sub>An unknown command, from <code>stills.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/themes.png" alt="pain-control-revamped: The header in six themes"><br><sub>The header in six themes, from <code>themes.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/help.png" alt="pain-control-revamped: The help page"><br><sub>The help page, from <code>help.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/accent.png" alt="pain-control-revamped: An accent from PAIN_CONTROL_REVAMPED_ACCENT"><br><sub>An accent from <code>PAIN_CONTROL_REVAMPED_ACCENT</code>, from <code>stills.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/zoom.png" alt="pain-control-revamped: The zoomed pane in its own window, with a pane opened beside it"><br><sub>The zoomed pane in its own window, with a pane opened beside it, from <code>zoom.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/zoom-placeholder.png" alt="pain-control-revamped: The placeholder holding the pane's place"><br><sub>The placeholder holding the pane's place, from <code>zoom.tape</code></sub></td>
<td width="50%" valign="top"><img src="screens/zoom-back.png" alt="pain-control-revamped: The pane back in its place"><br><sub>The pane back in its place, from <code>zoom.tape</code></sub></td>
</tr>
<tr>
<td width="50%" valign="top"><img src="screens/focus.png" alt="pain-control-revamped: The focused pane grown to 70 percent"><br><sub>The focused pane grown to 70 percent, from <code>zoom.tape</code></sub></td>
<td width="50%" valign="top"></td></tr>
</table>

</details>

## Portability

The plugin is POSIX `sh`. CI runs every suite on each row below.

| Shell | Status |
|:------|:-------|
| `dash`, `/bin/sh` on macOS | Supported |
| `bash` 3.2 and 5.x, the system's `zsh` and Homebrew's | Supported |

| System | Status |
|:-------|:-------|
| macOS | Tahoe on Apple Silicon and Intel, with the tools it ships, Homebrew's GNU tools and Homebrew's uutils |
| Linux | Ubuntu 26.04 on x86_64 and arm64, with GNU coreutils, uutils and BusyBox |

## Development

| Command | What it runs |
|:--------|:-------------|
| `make fmt` | shfmt `-i 2` on every script |
| `make lint` | shfmt, ShellCheck, mandoc, yamllint and actionlint, at zero findings |
| `make test` | The bats suites under the system `sh` |
| `make test-all` | The suites under every installed shell, both builds of bash and zsh on macOS |
| `make test-linux` | The suites in an Ubuntu container |
| `make coverage` | bashcov on this Mac and in the Ubuntu container, merged and gated at 100 percent |
| `make screens` | The screens above, recorded from the real plugin inside tmux with VHS, on macOS |
| `make install` | The command, its man page and completions under `PREFIX` |

Commits follow the conventional commit format and go straight to `main`. After a green `ci` run on `main`, `release.yml` runs semantic-release: every `feat` or `fix` since the last tag publishes a release, stamps the version constant and adds the notes to [`CHANGELOG.md`](CHANGELOG.md).

## License

[MIT](LICENSE), copyright Gustavo Franco.

<!-- family:begin -->

## The tmux-revamped family

This plugin is one member of the tmux-revamped family. Every member carries the same contract in [`FAMILY.md`](FAMILY.md) and the same shared library, and they are built to be installed together: no member claims a key or a tmux option that another member claims.

A defect found in one member is hunted across all of them before the fix is called done.

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
| [`tmux-launcher-revamped`](https://github.com/tmux-revamped/tmux-launcher-revamped) | Open any terminal app in a tmux popup, window or split from one menu, starting at the project root |
| [`tmux-logging-revamped`](https://github.com/tmux-revamped/tmux-logging-revamped) | Capture any pane to a file: live logging, full scrollback, or a one-shot screenshot |
| [`tmux-music-revamped`](https://github.com/tmux-revamped/tmux-music-revamped) | Now playing in your tmux status bar, without ever blocking the status render |
| [`tmux-network-revamped`](https://github.com/tmux-revamped/tmux-network-revamped) | Network throughput in your tmux status bar, without ever blocking the render |
| [`tmux-pain-control-revamped`](https://github.com/tmux-revamped/tmux-pain-control-revamped) | **this plugin**, Pane and window management bindings for tmux, version aware, vim friendly, every prefix key can be disabled |
| [`tmux-persist-revamped`](https://github.com/tmux-revamped/tmux-persist-revamped) | Save every tmux session, window and pane, auto-save on a timer, and restore it all after a reboot |
| [`tmux-plugin-template`](https://github.com/tmux-revamped/tmux-plugin-template) | The starting point for a tmux-revamped plugin: shared library, bats harness and CI |
| [`tmux-pomodoro-revamped`](https://github.com/tmux-revamped/tmux-pomodoro-revamped) | A Pomodoro timer in the tmux status bar that keeps all of its state in tmux options, with no temp files |
| [`tmux-ram-revamped`](https://github.com/tmux-revamped/tmux-ram-revamped) | RAM, swap and memory pressure in the tmux status bar, sampled in the background so the render never waits |
| [`tmux-reorder-revamped`](https://github.com/tmux-revamped/tmux-reorder-revamped) | Drag a window tab along the tmux status bar with the mouse to move that window |
| [`tmux-scroll-revamped`](https://github.com/tmux-revamped/tmux-scroll-revamped) | Send the mouse wheel to apps that scroll themselves and into tmux copy-mode everywhere else |
| [`tmux-sensible-revamped`](https://github.com/tmux-revamped/tmux-sensible-revamped) | Sensible tmux defaults, gated by tmux version and terminal, that leave the options you set alone |
| [`tmux-tiling-revamped`](https://github.com/tmux-revamped/tmux-tiling-revamped) | Tiling window management for tmux: eight layouts including BSP dwindle and spiral, with layout undo |
| [`tmux-time-revamped`](https://github.com/tmux-revamped/tmux-time-revamped) | Local and world clocks for the tmux status bar, colored by time of day, with countdowns and a DST warning |
| [`tmux-weather-revamped`](https://github.com/tmux-revamped/tmux-weather-revamped) | Weather for the tmux status bar from wttr.in, fetched in the background so the status line never waits |

<!-- family:end -->
