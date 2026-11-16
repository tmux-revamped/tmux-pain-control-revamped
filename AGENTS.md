# tmux-pain-control-revamped

Guidance for anyone, human or agent, changing tmux-pain-control-revamped. What it is and how to use it lives in [README.md](README.md).

[FAMILY.md](FAMILY.md) holds everything this plugin shares with the rest of the tmux-revamped family, and it is the same in every member. This file holds only what is exclusive to tmux-pain-control-revamped, under the same headings as the agent guide of every member. Read both before changing anything; a rule that would serve the other members goes into [`FAMILY.md`](FAMILY.md) instead of here.

## Layout

| Path | Holds |
|:-----|:------|
| [`pain-control-revamped.tmux`](pain-control-revamped.tmux) | The entry point TPM runs: it runs `bin/pain-control-revamped apply` |
| [`bin/pain-control-revamped`](bin/pain-control-revamped) | The command: `apply`, `list`, `doctor`, `version`, `help` and the menu. `apply` runs without loading the interface modules |
| [`lib/pain.sh`](lib/pain.sh) | Reading the settings, the version checks and the binding plan |
| [`lib/state.sh`](lib/state.sh) | Every global, including `PAIN_CONTROL_REVAMPED_SETTINGS`, the table of setting names and defaults the rest reads |
| [`lib/core.sh`](lib/core.sh) | The version |
| [`lib/`](lib) | Every other file is the shared library, identical in every member |
| [`test/pain.bats`](test/pain.bats), [`test/commands.bats`](test/commands.bats), [`test/entrypoint.bats`](test/entrypoint.bats) | This member's suites: the library, the commands, and the entry point on a private tmux server |
| [`screens/`](screens) | The tapes and the recording's tmux config, whose new panes start the demo shell |

## Names

- Settings are the tmux options `@pain_control_revamped_<setting>` listed in `PAIN_CONTROL_REVAMPED_SETTINGS`, the long options with dashes, such as `--join-key`, and the environment variables `PAIN_CONTROL_REVAMPED_<SETTING>`.
- It has no status placeholders.
- The version constant is `PAIN_CONTROL_REVAMPED_VERSION`.

## Behaviour

- `apply` reads every setting with one `tmux display-message` call and one `env` read, builds the plan, and sends every binding to tmux in one call separated by `;`. Nothing runs in the background afterwards.
- An empty tmux option means its default; an empty environment variable or long option leaves that key unbound.
- The entry point clears every inherited `REVAMPED_` variable except the test switches, and every `PAIN_CONTROL_REVAMPED_*_LOADED` guard; every other global is assigned outright in `lib/state.sh`.
- It declares stock key overrides for splits, resizing and pane movement, listed in the family key allocation.

## Domain rules

- Every binding carries a `-N` note on tmux 3.1 and later, so `prefix + ?` lists it.
- Version checks drop what an older tmux lacks: full splits need 2.3, marks 2.1, pane names and no-wrap 2.6, the `{top-left}` promote target 3.0, and the scratch popup 3.2.
- With vim navigation on, each chord runs `ps` on the pane's TTY and matches the process name against the vim pattern; a match sends the key to vim.

## Release

- `PAIN_CONTROL_REVAMPED_VERSION` in [`lib/core.sh`](lib/core.sh) holds the version. Nobody edits it by hand.
- After a green `ci` run on `main`, [`release.yml`](.github/workflows/release.yml) runs semantic-release: a `feat` or `fix` since the last tag publishes a release, [`set-version.sh`](.github/scripts/set-version.sh) stamps the constant, and the notes go into [`CHANGELOG.md`](CHANGELOG.md).

## Gaps against FAMILY.md

As of 2026-11-16, none.
