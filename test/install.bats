#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034

# shellcheck source=test/helpers.bash
source "${BATS_TEST_DIRNAME:-.}/helpers.bash"

setup() {
  harness_setup
  ROOT="$(cd "${REVAMPED_TESTS_DIR}/.." && pwd)"
}

complete_words() {
  # shellcheck source=completions/pain-control-revamped.bash
  source "${ROOT}/completions/pain-control-revamped.bash"
  COMP_WORDS=("$@")
  COMP_CWORD=$(($# - 1))
  _pain_control_revamped
  printf '%s\n' "${COMPREPLY[@]}"
}

@test "install - make install puts a working tool, its man page and completions under PREFIX" {
  # Arrange
  local prefix="${BATS_TEST_TMPDIR}/prefix with space"

  # Act
  make -s -C "${ROOT}" install PREFIX="${prefix}"

  # Assert
  run "${prefix}/bin/pain-control-revamped" version
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" == pain-control-revamped\ * ]]
  [[ -f "${prefix}/share/man/man1/pain-control-revamped.1" ]]
  [[ -f "${prefix}/share/bash-completion/completions/pain-control-revamped" ]]
  [[ -f "${prefix}/share/zsh/site-functions/_pain-control-revamped" ]]
  [[ -f "${prefix}/share/fish/vendor_completions.d/pain-control-revamped.fish" ]]
}

@test "install - a second install replaces the first" {
  # Arrange
  local prefix="${BATS_TEST_TMPDIR}/prefix"
  make -s -C "${ROOT}" install PREFIX="${prefix}"
  printf 'stale\n' >"${prefix}/share/pain-control-revamped/lib/stale.sh"

  # Act
  make -s -C "${ROOT}" install PREFIX="${prefix}"

  # Assert
  [[ ! -e "${prefix}/share/pain-control-revamped/lib/stale.sh" ]]
  [[ -x "${prefix}/bin/pain-control-revamped" ]]
}

@test "install - bash completes the commands" {
  # Arrange
  local word=d

  # Act
  run complete_words pain-control-revamped "${word}"

  # Assert
  [[ "${output}" == "doctor" ]]
}

@test "install - bash completes the themes after --theme" {
  # Arrange
  local word=no

  # Act
  run complete_words pain-control-revamped --theme "${word}"

  # Assert
  [[ "${output}" == "nord" ]]
}

@test "install - bash completes the setting options" {
  # Arrange
  local word=--swap-p

  # Act
  run complete_words pain-control-revamped "${word}"

  # Assert
  [[ "${output}" == "--swap-prev-key" ]]
}

@test "install - bash completes no word after a setting option" {
  # Arrange
  local word=""

  # Act
  run complete_words pain-control-revamped --join-key "${word}"

  # Assert
  [[ -z "${output}" ]]
}
