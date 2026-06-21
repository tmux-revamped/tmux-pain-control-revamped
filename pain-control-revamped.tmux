#!/usr/bin/env bash
#
# pain-control-revamped.tmux: TPM entry point.
#
# Applies the pane and window management bindings. Every binding is version
# gated, so this runs cleanly on every tmux version TPM supports (1.9 and up).

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "${CURRENT_DIR}/src/pain.sh"
