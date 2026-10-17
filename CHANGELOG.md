# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-17

### Changed

- **Breaking:** the plugin binds only splits, resizing and pane movement by
  default, so the tmux-revamped family installs with no key bound twice. Each
  other action is now unbound until its option is set: `S` sync
  (`@pane_control_sync_key`), `<` and `>` window swap
  (`@pane_control_swap_window_left_key`, `@pane_control_swap_window_right_key`,
  new), `.` move window (`@pane_control_move_window_key`), `&` kill window
  (`@pane_control_kill_window_key`), `E` `V` `B` layouts
  (`@pane_control_layout_even_h_key`, `@pane_control_layout_even_v_key`,
  `@pane_control_layout_main_v_key`), `R` respawn
  (`@pane_control_respawn_key`), `C` capture (`@pane_control_capture_key`),
  `P` pane name (`@pane_control_pane_name_key`) and `g` scratch popup
  (`@pane_control_scratch_key`). Set an option to its old key to restore it.
  Navigation, resize, the splits, `*`, `c`, `@`, `!`, `{`, `}`, `+`, `m` and
  `=` keep their keys.

### Fixed

- Version checks compare major and minor numerically in bash instead of
  relying on `sort -V`, which some `sort` implementations lack.
- Negative test assertions that were not the last line of a test now fail
  the test when they do not hold.
- Smart vim navigation detects vim again: the default `is_vim` pattern
  carried doubled backslashes that reached `grep` literally, so no pane ever
  matched and `Ctrl+h/j/k/l` always moved the tmux pane.
- `@pane_control_disabled_keys` no longer expands glob characters, so listing
  `*` disables the smart-split key instead of matching file names.

## [1.1.0] - 2026-06-30

### Added

- Pane workflow bindings: join a pane in (`@`) and break one out (`!`), swap with
  the previous or next pane (`{` `}`), promote a pane to the main slot (`+`), and
  a marked-pane swap (`m` to mark, `=` to swap) on tmux 2.1 and up.
- Smart split (`*`) that picks the longer axis and keeps the current path, plus
  even-horizontal, even-vertical, and main-vertical layout presets (`E` `V` `B`).
- Window helpers: move the current window to another session by name (`.`) and a
  confirm-before kill-window (`&`).
- Respawn the current pane in place after a confirm (`R`), capture the whole
  scrollback to a file (`C`), name a pane from a prompt (`P`, tmux 2.6 and up),
  and an optional pane-title border via `@pane_control_pane_titles` (tmux 2.3+).
- Ephemeral scratch popup shell (`g`) on tmux 3.2 and up, with an optional
  `@pane_control_scratch_command` to run a specific tool.
- Edge no-wrap pane selection via `@pane_control_no_wrap` (tmux 2.6 and up), and
  a restored prefixed `C-l` clear-screen when smart vim navigation is on.
- An option for every new key so any binding can be remapped, and every new key
  honors `@pane_control_disabled_keys`.

## [1.0.1] - 2026-06-23

### Changed

- Rechecked the binding set against upstream `tmux-plugins/tmux-pain-control`.
  Pane navigation, repeatable resizing, directory-preserving splits, window
  swapping, and the synchronize-panes toggle are all present, each carries a
  `-N` key description, and the plugin adds full-width and full-height splits
  plus optional vim navigation beyond the upstream. No code change needed.

## [1.0.0] - 2026-06-21

### Added

- Pane navigation (h/j/k/l and C-h/j/k/l), repeatable resizing with a
  configurable step, splits that keep the current directory including the
  default `"` and `%` keys, new window in the current path, repeatable window
  move, and a synchronize-panes toggle.
- Version gating for tmux 1.9 and up: full splits use `-f` on 2.3+, the
  copy-mode table is used on 2.4+, and binding description notes on 3.1+.
- Configurable keys and an `@pane_control_disabled_keys` option so any binding
  can be turned off to avoid a conflict.
- Optional prefixless Ctrl+h/j/k/l navigation that detects vim with the standard
  is_vim check, off by default, to coexist with or replace vim-tmux-navigator.
