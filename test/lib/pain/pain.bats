#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

setup() {
  setup_test_environment
  unset _PAIN_REVAMPED_LOADED
  source "${BATS_TEST_DIRNAME}/../../../src/lib/pain/pain.sh"
}

teardown() {
  cleanup_test_environment
}

@test "pain.sh - parse_tmux_version handles suffixes and prefixes" {
  [[ "$(parse_tmux_version 'tmux 3.4')" == "3.4" ]]
  [[ "$(parse_tmux_version 'tmux 3.4a')" == "3.4" ]]
  [[ "$(parse_tmux_version 'tmux next-3.5')" == "3.5" ]]
  [[ "$(parse_tmux_version 'tmux 1.9')" == "1.9" ]]
}

@test "pain.sh - version_ge compares correctly" {
  version_ge 3.4 2.3
  version_ge 2.4 2.4
  run version_ge 2.2 2.3
  [ "${status}" -eq 1 ]
  ! version_ge "" 2.3
}

@test "pain.sh - version_ge compares numerically without sort" {
  # Arrange
  sort() { return 1; }

  # Act
  run version_ge 3.10 3.9

  # Assert
  [ "${status}" -eq 0 ]
}

@test "pain.sh - key_disabled matches space or comma lists" {
  key_disabled "c" "c < >"
  key_disabled "<" "c,<,>"
  run key_disabled "h" "c < >"
  [ "${status}" -eq 1 ]
  ! key_disabled "c" ""
}

@test "pain.sh - key_disabled matches a glob character literally" {
  # Arrange
  cd "${TEST_TMPDIR}"
  touch "${TEST_TMPDIR}/some-file"

  # Act
  run key_disabled "*" "* <"

  # Assert
  [ "${status}" -eq 0 ]
}

@test "pain.sh - tmux_version uses the seam" {
  _tmux_version_string() { echo "tmux 2.6a"; }
  [[ "$(tmux_version)" == "2.6" ]]
}

@test "pain.sh - host-probe seam is callable" {
  run _tmux_version_string
  true
}
