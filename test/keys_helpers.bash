#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/tmux_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/tmux_helpers.bash"

screens() {
  printf 'host screen:\n'
  command tmux -S "${HOST}" capture-pane -p -t host || :
  printf 'panes:\n'
  tmux list-panes -a -F '#{window_index}:#{window_name} #{pane_id} #{pane_left},#{pane_top} #{pane_width}x#{pane_height} active=#{pane_active} #{pane_current_path}' || :
}

wait_for() {
  local delay
  for delay in 0.01 0.02 0.05 0.1 0.1 0.2 0.2 0.5 0.5 1 1 1 2 2; do
    "$@" && return 0
    sleep "${delay}"
  done
  "$@" && return 0
  screens
  return 1
}

attached() {
  local clients
  clients=$(tmux list-clients -F x 2>/dev/null)
  [[ -n "${clients}" ]]
}

shows() {
  local now
  now=$(tmux display-message -p -t "$1" "$2" 2>/dev/null)
  [[ "${now}" == "$3" ]]
}

differs() {
  local now
  now=$(tmux display-message -p -t "$1" "$2" 2>/dev/null)
  [[ -n "${now}" && "${now}" != "$3" ]]
}

host_shows() {
  local screen
  screen=$(command tmux -S "${HOST}" capture-pane -p -t host)
  [[ "${screen}" == *"$1"* ]]
}

pane_shows() {
  local screen
  screen=$(tmux capture-pane -p -t "$1")
  [[ "${screen}" == *"$2"* ]]
}

panes_are() {
  local ids
  ids=$(tmux list-panes -t test:0 -F '#{pane_id}')
  ids=$(paste -sd ' ' - <<<"${ids}")
  [[ "${ids}" == "$1" ]]
}

windows_are() {
  local names
  names=$(tmux list-windows -t "$1" -F '#{window_name}')
  names=$(paste -sd ' ' - <<<"${names}")
  [[ "${names}" == "$2" ]]
}

file_holds() {
  [[ -f "$1" ]] || return 1
  grep -qF -- "$2" "$1"
}

setup() {
  ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "${HOME}" "${BATS_TEST_TMPDIR}/stubs"
  setup_tmux_server
  HOST="${TMUX_SOCKET}-host"
  tmux set-option -g default-command "env PS1='new> ' sh"
  tmux rename-window -t test: a
  tmux respawn-pane -k -t test:0.0 "env PS1='$ ' sh"
  command tmux -S "${HOST}" -f /dev/null new-session -d -s host -x 120 -y 30 \
    "env -u TMUX TERM=xterm-256color tmux -S '${TMUX_SOCKET}' attach-session -t test"
  wait_for attached
  wait_for shows test: '#{window_width}x#{window_height}' 120x29
}

teardown() {
  command tmux -S "${HOST}" kill-server 2>/dev/null || :
  rm -f "${HOST}"
  teardown_tmux_server
}

load_plugin() {
  local quoted
  quoted=$(printf '%s' "$1" | sed "s/'/'\\\\''/g")
  tmux run-shell "'${quoted}/pain-control-revamped.tmux'"
}

key() {
  set_option "@pain_control_revamped_$1" "$2"
}

press() {
  command tmux -S "${HOST}" send-keys -t host "$@"
}

in_folder() {
  WORK="${BATS_TEST_TMPDIR}/work dir"
  mkdir -p "${WORK}"
  WORK=$(cd "${WORK}" && pwd -P)
  tmux send-keys -t "$1" "cd '${WORK}'" Enter
  wait_for shows "$1" '#{pane_current_path}' "${WORK}"
}

reads_keys() {
  tmux send-keys -t "$1" "stty -icanon -isig -echo; echo re''ady; while :; do dd bs=1 count=1 2>/dev/null | od -An -tx1; done" Enter
  wait_for pane_shows "$1" ready
}
