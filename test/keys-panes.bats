#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/keys_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/keys_helpers.bash"

bats_require_minimum_version 1.5.0

@test "keys - prefix h selects the pane on the left" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b h

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - prefix C-h selects the pane on the left" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-b C-h

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - prefix l selects the pane on the right" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b l

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - prefix C-l selects the pane on the right" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b C-l

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - prefix j selects the pane below" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press C-b j

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - prefix C-j selects the pane below" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press C-b C-j

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - prefix k selects the pane above" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test

  # Act
  press C-b k

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - prefix C-k selects the pane above" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test

  # Act
  press C-b C-k

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - with no wrap, prefix h stays at the left edge, so prefix l then reaches the middle pane" {
  # Arrange
  key no_wrap on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b h

  # Assert
  press C-b l
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - prefix H moves the right border of the pane left by the resize step" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b H

  # Assert
  wait_for shows %0 '#{pane_width}' 55
}

@test "keys - prefix L moves the right border of the pane right by the resize step" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b L

  # Assert
  wait_for shows %0 '#{pane_width}' 65
}

@test "keys - prefix K moves the bottom border of the pane up by the resize step" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press C-b K

  # Assert
  wait_for shows %0 '#{pane_height}' 9
}

@test "keys - prefix J moves the bottom border of the pane down by the resize step" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press C-b J

  # Assert
  wait_for shows %0 '#{pane_height}' 19
}

@test "keys - the resize setting sets the step of prefix H" {
  # Arrange
  key resize 3
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-b H

  # Assert
  wait_for shows %0 '#{pane_width}' 57
}

@test "keys - prefix | splits to the right in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b '|'

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 61,0
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix % splits to the right in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b '%'

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 61,0
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix - splits down in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b -

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 0,15
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix \" splits down in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b '"'

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 0,15
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix \\ splits the whole window to the right in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  in_folder %1

  # Act
  press C-b "\\"

  # Assert
  wait_for shows %2 '#{pane_left},#{pane_top} #{pane_height}' '61,0 29'
  wait_for shows %2 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix _ splits the whole window down in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  in_folder %1

  # Act
  press C-b _

  # Assert
  wait_for shows %2 '#{pane_left},#{pane_top} #{pane_width}' '0,15 120'
  wait_for shows %2 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix * splits a wide pane to the right in its folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b '*'

  # Assert
  wait_for shows %1 '#{pane_left},#{pane_top}' 61,0
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix * splits a tall pane down in its folder" {
  # Arrange
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux resize-pane -t %0 -x 20
  tmux select-pane -t %0
  in_folder %0

  # Act
  press C-b '*'

  # Assert
  wait_for shows %2 '#{pane_left},#{pane_top} #{pane_width}' '0,15 20'
  wait_for shows %2 '#{pane_current_path}' "${WORK}"
}

@test "keys - prefix c opens a window in the pane's folder" {
  # Arrange
  load_plugin "${ROOT}"
  in_folder %0

  # Act
  press C-b c

  # Assert
  wait_for shows test: '#{session_windows} #{pane_id}' '2 %1'
  wait_for shows %1 '#{pane_current_path}' "${WORK}"
}
