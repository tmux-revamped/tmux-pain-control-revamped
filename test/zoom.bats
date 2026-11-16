#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/tmux_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/tmux_helpers.bash"

bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  setup_tmux_server
  tmux rename-window -t test main
  tmux split-window -h -t test
}

teardown() {
  teardown_tmux_server
}

zoom() {
  # shellcheck disable=SC2086
  TMUX="${TMUX_SOCKET},1,0" TMUX_PANE="$1" run --separate-stderr ${REVAMPED_TEST_SHELL:-sh} "${ROOT}/bin/pain-control-revamped" zoom
}

panes() {
  tmux list-panes -a -F '#{window_name} #{pane_id} #{pane_width}x#{pane_height} of=#{@pain_control_revamped_zoom_of} hold=#{@pain_control_revamped_zoom_hold}'
}

@test "zoom - the pane moves to its own window and a placeholder keeps its place" {
  # Arrange
  local pane=%0

  # Act
  zoom "${pane}"

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${lines[0]}" == "main %2 100x50 of=%0 hold=" ]]
  [[ "${lines[1]}" == "main %1 99x50 of= hold=" ]]
  [[ "${lines[2]}" == "zoom %0 %0 200x50 of= hold=%2" ]]
  run tmux display-message -p '#{window_name} #{pane_id}'
  [[ "${output}" == "zoom %0 %0" ]]
}

@test "zoom - zooming the pane again puts it back and keeps the panes opened beside it" {
  # Arrange
  zoom %0
  tmux split-window -t %0

  # Act
  zoom %0

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${lines[0]}" == "main %0 100x50 of= hold=" ]]
  [[ "${lines[1]}" == "main %1 99x50 of= hold=" ]]
  [[ "${lines[2]}" == "zoom %0 %3 200x50 of= hold=" ]]
  run tmux display-message -p '#{pane_id}'
  [[ "${output}" == "%0" ]]
}

@test "zoom - zooming the placeholder puts the pane back and closes the empty window" {
  # Arrange
  zoom %0

  # Act
  zoom %2

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${output}" == $'main %0 100x50 of= hold=\nmain %1 99x50 of= hold=' ]]
}

@test "zoom - a placeholder whose pane is gone closes" {
  # Arrange
  zoom %0
  tmux kill-pane -t %0

  # Act
  zoom %2

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${output}" == "main %1 200x50 of= hold=" ]]
}

@test "zoom - a zoomed pane whose placeholder is gone stays and forgets it" {
  # Arrange
  zoom %0
  tmux kill-pane -t %2

  # Act
  zoom %0

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${output}" == $'main %1 200x50 of= hold=\nzoom %0 %0 200x50 of= hold=' ]]
}

@test "zoom - a pane alone in its window stays where it is" {
  # Arrange
  tmux kill-pane -t %1

  # Act
  zoom %0

  # Assert
  [[ "${status}" -eq 0 ]]
  run panes
  [[ "${output}" == "main %0 200x50 of= hold=" ]]
}

@test "zoom - without a tmux pane the command fails and says why" {
  # Arrange
  teardown_tmux_server

  # Act
  # shellcheck disable=SC2086
  TMUX="${TMUX_SOCKET},1,0" run --separate-stderr ${REVAMPED_TEST_SHELL:-sh} "${ROOT}/bin/pain-control-revamped" zoom

  # Assert
  [[ "${status}" -eq 1 ]]
  [[ "${stderr}" == "pain-control-revamped: no tmux pane to zoom." ]]
}

@test "zoom - the bound key zooms from a checkout path with a space, a hash and a quote" {
  # Arrange
  local copy="${BATS_TEST_TMPDIR}/it's #1 dir" binding
  mkdir -p "${copy}"
  cp -Rf "${ROOT}/bin" "${ROOT}/lib" "${copy}/"
  binding=$(PAIN_CONTROL_REVAMPED_ZOOM_KEY=Z sh "${copy}/bin/pain-control-revamped" list | grep 'Power zoom')

  # Act
  tmux run-shell -t %0 "${binding#*run-shell }"

  # Assert
  run panes
  [[ "${lines[2]}" == "zoom %0 %0 200x50 of= hold=%2" ]]
}
