#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/keys_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/keys_helpers.bash"

bats_require_minimum_version 1.5.0

@test "keys - the swap window right key moves the window one place right" {
  # Arrange
  key swap_window_right_key '>'
  load_plugin "${ROOT}"
  tmux new-window -d -t test: -n b

  # Act
  press C-b '>'

  # Assert
  wait_for windows_are test 'b a'
}

@test "keys - the swap window left key moves the window one place left" {
  # Arrange
  key swap_window_left_key '<'
  load_plugin "${ROOT}"
  tmux new-window -t test: -n b

  # Act
  press C-b '<'

  # Assert
  wait_for windows_are test 'b a'
}

@test "keys - the move window key asks for a session and moves the window there" {
  # Arrange
  key move_window_key M
  load_plugin "${ROOT}"
  tmux new-window -d -t test: -n b
  tmux new-session -d -s other -n main

  # Act
  press C-b M

  # Assert
  wait_for host_shows "move window to session:"
  press 'other:' Enter
  wait_for windows_are other 'main a'
  wait_for windows_are test 'b'
}

@test "keys - the kill window key asks with the window's name and kills it on y" {
  # Arrange
  key kill_window_key X
  load_plugin "${ROOT}"
  tmux new-window -d -t test: -n b

  # Act
  press C-b X

  # Assert
  wait_for host_shows "kill-window a? (y/n)"
  press y
  wait_for windows_are test 'b'
}

@test "keys - prefix @ asks for a pane and joins it beside this one" {
  # Arrange
  load_plugin "${ROOT}"
  tmux new-window -d -t test: -n b

  # Act
  press C-b @

  # Assert
  wait_for host_shows "join pane from:"
  press 'test:1.0' Enter
  wait_for panes_are '%0 %1'
  wait_for shows %1 '#{pane_left},#{pane_top}' 61,0
}

@test "keys - prefix ! breaks the pane out to its own window" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b '!'

  # Assert
  wait_for shows test: '#{session_windows}' 2
  wait_for panes_are '%0'
}

@test "keys - prefix { swaps the pane with the one before it" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b '{'

  # Assert
  wait_for panes_are '%1 %0'
}

@test "keys - prefix } swaps the pane with the one after it" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b '}'

  # Assert
  wait_for panes_are '%1 %0'
}

@test "keys - prefix + promotes the pane to the top left place" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux split-window -v -t test

  # Act
  press C-b +

  # Assert
  wait_for panes_are '%2 %1 %0'
}

@test "keys - prefix m marks the pane" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b m

  # Assert
  wait_for shows %1 '#{pane_marked}' 1
}

@test "keys - prefix = swaps the pane with the marked one" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -m -t %0

  # Act
  press C-b =

  # Assert
  wait_for panes_are '%1 %0'
}

@test "keys - the even-horizontal layout key puts stacked panes side by side" {
  # Arrange
  key layout_even_h_key E
  load_plugin "${ROOT}"
  tmux split-window -v -t test

  # Act
  press C-b E

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 61,0
}

@test "keys - the even-vertical layout key stacks panes that were side by side" {
  # Arrange
  key layout_even_v_key V
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b V

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 0,15
}

@test "keys - the main-vertical layout key gives the first pane the whole height" {
  # Arrange
  key layout_main_v_key B
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux split-window -v -t test

  # Act
  press C-b B

  # Assert
  wait_for shows %0 '#{pane_left},#{pane_top} #{pane_height}' '0,0 29'
}

@test "keys - the respawn key asks and restarts the pane's command on y" {
  # Arrange
  local before
  key respawn_key R
  load_plugin "${ROOT}"
  before=$(tmux display-message -p -t %0 '#{pane_pid}')

  # Act
  press C-b R

  # Assert
  wait_for host_shows "respawn-pane? (y/n)"
  press y
  wait_for differs %0 '#{pane_pid}' "${before}"
}

@test "keys - the capture key offers a file under HOME and saves the scrollback there" {
  # Arrange
  key capture_key P
  load_plugin "${ROOT}"
  tmux send-keys -t %0 "echo scroll''back-line" Enter
  wait_for pane_shows %0 scrollback-line

  # Act
  press C-b P

  # Assert
  wait_for host_shows "save scrollback to: ${HOME}/tmux-scrollback.log"
  press Enter
  wait_for file_holds "${HOME}/tmux-scrollback.log" scrollback-line
}

@test "keys - the pane name key asks for a title and sets it" {
  # Arrange
  key pane_name_key N
  load_plugin "${ROOT}"

  # Act
  press C-b N

  # Assert
  wait_for host_shows "pane title:"
  press 'work' Enter
  wait_for shows %0 '#{pane_title}' work
}

@test "keys - the scratch key runs its command in a popup in the pane's folder" {
  # Arrange
  local out="${BATS_TEST_TMPDIR}/scratch.out"
  key scratch_key T
  key scratch_command "pwd -P >'${out}'"
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b T

  # Assert
  wait_for file_holds "${out}" "${WORK}"
}

@test "keys - the scratch key opens a shell in a popup in the pane's folder" {
  # Arrange
  local out="${BATS_TEST_TMPDIR}/scratch.out"
  key scratch_key T
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b T

  # Assert
  wait_for host_shows "new> "
  press "pwd -P >'${out}'; exit" Enter
  wait_for file_holds "${out}" "${WORK}"
}

@test "keys - the sync key turns pane sync on and says so" {
  # Arrange
  key sync_key S
  load_plugin "${ROOT}"

  # Act
  press C-b S

  # Assert
  wait_for host_shows "synchronize-panes on"
  wait_for shows test:0 '#{synchronize-panes}' 1
}

@test "keys - the zoom key moves the pane to its own window, from a checkout path with a space, a quote and a hash" {
  # Arrange
  local copy="${BATS_TEST_TMPDIR}/it's #1 dir"
  mkdir -p "${copy}"
  cp -Rf "${ROOT}/bin" "${ROOT}/lib" "${ROOT}/pain-control-revamped.tmux" "${copy}/"
  key zoom_key Z
  load_plugin "${copy}"
  tmux split-window -h -t test

  # Act
  press C-b Z

  # Assert
  wait_for shows %1 '#{window_name}' 'zoom %1'
}
