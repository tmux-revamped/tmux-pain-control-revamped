#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034

# shellcheck source=test/helpers.bash
source "${BATS_TEST_DIRNAME:-.}/helpers.bash"

bats_require_minimum_version 1.5.0

setup() {
  harness_setup
  for name in $(compgen -v PAIN_CONTROL_REVAMPED_) KODOUGU_THEME KODOUGU_ACCENT NO_COLOR; do
    unset "${name}"
  done
}

tool() {
  # shellcheck disable=SC2086
  run ${REVAMPED_TEST_SHELL:-sh} "${REVAMPED_TESTS_DIR}/../bin/pain-control-revamped" "$@"
}

plain_tty() {
  local shell_words
  read -r -a shell_words <<<"${REVAMPED_TEST_SHELL:-sh}"
  run python3 "${REVAMPED_TESTS_DIR}/on_tty.py" "${shell_words[@]}" "${REVAMPED_TESTS_DIR}/../bin/pain-control-revamped"
}

@test "commands - list prints every binding apply would make" {
  # Arrange
  local command=list

  # Act
  tool "${command}"

  # Assert
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" == "bind-key -N Select pane left h select-pane -L" ]]
  [[ "${#lines[@]}" -eq 27 ]]
}

@test "commands - list --json prints one JSON object" {
  # Arrange
  export PAIN_CONTROL_REVAMPED_DISABLED_KEYS='C-h j C-j k C-k l C-l H J K L | - " % \ _ * c @ ! { } + m ='

  # Act
  tool list --json

  # Assert
  [[ "${output}" == '{"bindings":[["bind-key","-N","Select pane left","h","select-pane","-L"]]}' ]]
}

@test "commands - an option in both forms wins over the environment" {
  # Arrange
  export PAIN_CONTROL_REVAMPED_JOIN_KEY=J

  # Act
  tool --join-key=Y --resize 2 list

  # Assert
  [[ "${output}" == *"bind-key -N Join pane Y command-prompt"* ]]
  [[ "${output}" == *"resize-pane -L 2"* ]]
}

@test "commands - apply binds every key in one tmux call and prints nothing" {
  # Arrange
  export REVAMPED_TEST_TMUX_ARGV="${BATS_TEST_TMPDIR}/argv"

  # Act
  # shellcheck disable=SC2086
  run --separate-stderr ${REVAMPED_TEST_SHELL:-sh} "${REVAMPED_TESTS_DIR}/../bin/pain-control-revamped" apply

  # Assert
  [[ "${status}" -eq 0 ]]
  [[ -z "${output}" ]]
  run grep -c '^bind-key' "${REVAMPED_TEST_TMUX_ARGV}"
  [[ "${output}" == "1" ]]
}

@test "commands - the menu applies the keys and counts them" {
  # Arrange
  harness_hide gum

  # Act
  plain_tty <<<"2"

  # Assert
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == *"Applied. 27 keys are bound."* ]]
}

@test "commands - the menu runs doctor" {
  # Arrange
  harness_hide gum

  # Act
  plain_tty <<<"3"

  # Assert
  [[ "${output}" =~ tmux\ +ok ]]
}

@test "commands - an unknown option is a usage error even without a value" {
  # Arrange
  local option=--colour

  # Act
  tool "${option}"

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "pain-control-revamped: unknown option '--colour'. run 'pain-control-revamped help' for usage." ]]
}

@test "commands - an unknown option with a value is a usage error" {
  # Arrange
  local option=--colour=red

  # Act
  tool "${option}" list

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "pain-control-revamped: unknown option '--colour'. run 'pain-control-revamped help' for usage." ]]
}

@test "commands - a setting option without its value is a usage error" {
  # Arrange
  local option=--resize

  # Act
  tool list "${option}"

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "pain-control-revamped: option '--resize' needs a value. run 'pain-control-revamped help' for usage." ]]
}

@test "commands - a single-dash option is a usage error" {
  # Arrange
  local option=-x

  # Act
  tool "${option}"

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "pain-control-revamped: unknown option '-x'. run 'pain-control-revamped help' for usage." ]]
}

@test "commands - --json with any command but list is a usage error" {
  # Arrange
  local flag=--json

  # Act
  tool "${flag}" apply

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${output}" == "pain-control-revamped: option '--json' works only with list. run 'pain-control-revamped help' for usage." ]]
}

@test "commands - -- ends the options" {
  # Arrange
  local command=list

  # Act
  tool --theme nord -- "${command}"

  # Assert
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" == bind-key\ * ]]
}

@test "commands - an inherited guard variable of the plugin is ignored" {
  # Arrange
  export PAIN_CONTROL_REVAMPED_PAIN_LOADED=1 PAIN_CONTROL_REVAMPED_CORE_LOADED=1

  # Act
  tool version

  # Assert
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" =~ ^pain-control-revamped\ [0-9]+\.[0-9]+\.[0-9]+$ ]]
}
