# tmux-pain-control-revamped

Guidance for anyone, human or agent, changing tmux-pain-control-revamped. What it is and how to use it lives in [README.md](README.md).

[FAMILY.md](FAMILY.md) holds everything this plugin shares with the rest of the tmux-revamped family, and it is the same in every member. This file holds only what is exclusive to tmux-pain-control-revamped, under the same headings as the agent guide of every member. Read both before changing anything; a rule that would serve the other members goes into [`FAMILY.md`](FAMILY.md) instead of here.

## Layout

| Path | Holds |
|:-----|:------|
| [`pain-control-revamped.tmux`](pain-control-revamped.tmux) | The entry point TPM runs |
| [`src/pain.sh`](src/pain.sh) | The script the entry point and the keys call |
| [`src/lib/pain/`](src/lib/pain) | This member's modules |
| [`src/lib/utils/constants.sh`](src/lib/utils/constants.sh) | This member's constants, including its version |
| [`src/lib/utils/`](src/lib/utils), [`src/lib/tmux/`](src/lib/tmux) | The shared library. Every file there except `constants.sh` is identical in every member |
| [`test/`](test) | The bats suite. `helpers.bash` and `tmux_helpers.bash` are identical in every member; this member's own mocks go in the `_local` files |

## Names

- Settings are meant to be tmux options named `@pain_control_revamped_<setting>`; see the gaps for the ones that are not yet.
- It has no status placeholders.
- The version constant is `PAIN_CONTROL_REVAMPED_VERSION`.
- `PAIN_DRY_RUN` is read from the environment.
- Its command-line tool, once it exists, is `pain-control-revamped`.

## Behaviour

- Binds better pane and window management keys, aware of the tmux version and of vim, with every key able to be turned off.
- It declares stock key overrides for splits, resizing and pane movement, listed in the family key allocation.
- The entry point runs [`src/pain.sh`](src/pain.sh) once at load, which reads the options and the tmux version and issues `bind-key` for each key. Nothing runs in the background afterwards.

## Domain rules

- Every binding carries a `-N` note, so `prefix + ?` lists it with a description.
- Version checks drop what an older tmux lacks: full splits need 2.3, marks 2.1, pane names and edge no-wrap 2.6, the `{top-left}` promote target 3.0, and the scratch popup 3.2.
- With vim navigation on, each chord runs `ps` on the pane's TTY and matches the process name against the vim pattern; a match sends the key to vim.
- `PAIN_DRY_RUN` prints each tmux command instead of running it, which is how the suite checks the bindings.

## Release

- `PAIN_CONTROL_REVAMPED_VERSION` in [`src/lib/utils/constants.sh`](src/lib/utils/constants.sh) holds the version. It must equal the newest versioned heading in [`CHANGELOG.md`](CHANGELOG.md) and the README's version badge, which the `version` job in `tests.yml` checks.
- A push to `main` whose version has no tag yet makes the `release` job in `tests.yml` tag `vX.Y.Z` and publish a GitHub release with that changelog section.
- Unreleased changes sit under `## [Unreleased]` in [`CHANGELOG.md`](CHANGELOG.md) until a release is cut.

## Gaps against FAMILY.md

As of 2026-11-15:

- Every script is bash, under `#!/usr/bin/env bash`, not POSIX `sh`, so it is untested under `dash`, `zsh` and BusyBox `sh`.
- The code lives in [`src/`](src) and [`src/lib/`](src/lib); there is no `bin/pain-control-revamped`, `lib/state.sh` or `lib/core.sh`.
- No `pain-control-revamped` command with `help`, `version` and `doctor` in the family's form, no man page, no completions and no `manifest.json`.
- No gum interface: no `lib/ui.sh`, `lib/table.awk`, themes or `test/bin/gum`.
- No `screens/`: no VHS recording of each feature, no on-screen caption of the keys each recording presses, and no recordings in the README.
- The README sections are not the family's order of Quick start, Usage, topic sections, Portability, Development and License.
- Coverage is kcov with a 95 percent floor on Linux, not bashcov at 100 percent merged from macOS and Linux.
- CI tests GNU, BSD and uutils tools in `tests.yml`, but not the six toolsets through `.github/scripts/toolset.sh`, and no shell matrix under `sh`, `dash`, `bash` and `zsh`.
- No golden transcripts, `call.sh`, `run-matrix.sh` or `linux-container.sh`.
- The version is written by hand and released by `tests.yml`; there is no semantic-release, `package.json`, `release.yml` with `recover`, `bot-merge.yml` or Renovate.
- CI is `tests.yml` and `security.yml`, not `ci.yml`, and no job starts with `step-security/harden-runner`.
- No `.editorconfig`, `.yamllint.yml` or shfmt; the Makefile has `help`, `test`, `test-unit`, `coverage`, `lint` and `clean`, not the family's targets.
- Its settings are named `@pane_control_*`, `@new_window_path` and `@pane_resize`, outside the `@pain_control_revamped_*` pattern.
