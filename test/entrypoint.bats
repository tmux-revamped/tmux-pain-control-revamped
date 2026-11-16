#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/tmux_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/tmux_helpers.bash"

setup() {
  ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  setup_tmux_server
}

teardown() {
  teardown_tmux_server
}

load_plugin() {
  local quoted
  quoted=$(printf '%s' "$1" | sed "s/'/'\\\\''/g")
  tmux run-shell "'${quoted}/pain-control-revamped.tmux'"
}

key_binding() {
  local table
  table=$(tmux list-keys -T "$1")
  awk -v key="$2" '{ for (i = 1; i < NF; i++) { if ($i == "-T") { if ($(i + 2) == key) { print } break } } }' <<<"${table}"
}

@test "entrypoint - loading binds the pane keys with their notes" {
  # Arrange
  local key='|'

  # Act
  load_plugin "${ROOT}"

  # Assert
  run key_binding prefix "${key}"
  [[ "${output}" == *'split-window -h -c "#{pane_current_path}"'* ]]
  run tmux list-keys -N -T prefix
  [[ "${output}" == *"Split right"* ]]
}

@test "entrypoint - a disabled key keeps the binding tmux had" {
  # Arrange
  set_option @pain_control_revamped_disabled_keys '%'

  # Act
  load_plugin "${ROOT}"

  # Assert
  run key_binding prefix '\\%'
  [[ "${output}" == *"split-window -h"* ]]
  [[ "${output}" != *"pane_current_path"* ]]
}

@test "entrypoint - vim navigation binds the root chords" {
  # Arrange
  set_option @pain_control_revamped_vim_navigation on

  # Act
  load_plugin "${ROOT}"

  # Assert
  run key_binding root C-h
  [[ "${output}" == *"if-shell"*"send-keys C-h"*"select-pane -L"* ]]
}

@test "entrypoint - a checkout path with a space, a hash and a quote still loads" {
  # Arrange
  local copy="${BATS_TEST_TMPDIR}/it's #1 dir"
  mkdir -p "${copy}"
  cp -Rf "${ROOT}/bin" "${ROOT}/lib" "${ROOT}/pain-control-revamped.tmux" "${copy}/"

  # Act
  load_plugin "${copy}"

  # Assert
  run key_binding prefix '|'
  [[ "${output}" == *"pane_current_path"* ]]
}

@test "entrypoint - git tracks the entry point and the tool as executable" {
  # Arrange
  local entry=pain-control-revamped.tmux tool=bin/pain-control-revamped

  # Act
  run git -C "${ROOT}" ls-files --stage -- "${entry}" "${tool}"

  # Assert
  [[ "${lines[0]}" == 100755\ * ]]
  [[ "${lines[1]}" == 100755\ * ]]
}
