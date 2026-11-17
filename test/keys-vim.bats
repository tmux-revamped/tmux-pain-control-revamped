#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/keys_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/keys_helpers.bash"

bats_require_minimum_version 1.5.0

@test "keys - with vim navigation, C-h selects the pane on the left" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test

  # Act
  press C-h

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - with vim navigation, C-j selects the pane below" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press C-j

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - with vim navigation, C-k selects the pane above" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -v -t test

  # Act
  press C-k

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - with vim navigation, C-l selects the pane on the right" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux select-pane -t %0

  # Act
  press C-l

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - with vim navigation, C-\\ selects the pane used before" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux split-window -v -t test
  tmux select-pane -t %0

  # Act
  press "C-\\"

  # Assert
  wait_for shows test: '#{pane_id}' %2
}

@test "keys - with vim navigation, C-h goes to a pane that says it runs vim" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux set-option -p -t %1 @pane-is-vim 1
  reads_keys %1

  # Act
  press C-h

  # Assert
  wait_for pane_shows %1 ' 08'
}

@test "keys - with vim navigation, C-j goes to a pane that says it runs vim" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux set-option -p -t %1 @pane-is-vim 1
  reads_keys %1

  # Act
  press C-j

  # Assert
  wait_for pane_shows %1 ' 0a'
}

@test "keys - with vim navigation, C-k goes to a pane that says it runs vim" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux set-option -p -t %1 @pane-is-vim 1
  reads_keys %1

  # Act
  press C-k

  # Assert
  wait_for pane_shows %1 ' 0b'
}

@test "keys - with vim navigation, C-l goes to a pane that says it runs vim" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux set-option -p -t %1 @pane-is-vim 1
  reads_keys %1

  # Act
  press C-l

  # Assert
  wait_for pane_shows %1 ' 0c'
}

@test "keys - with vim navigation, C-\\ goes to a pane that says it runs vim" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux set-option -p -t %1 @pane-is-vim 1
  reads_keys %1

  # Act
  press "C-\\"

  # Assert
  wait_for pane_shows %1 ' 1c'
}

@test "keys - with vim navigation, C-h goes to a pane whose process is named vim" {
  # Arrange
  local shell
  shell=$(command -v dash)
  ln -s "${shell}" "${BATS_TEST_TMPDIR}/stubs/vim"
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux split-window -h -t test
  tmux send-keys -t %1 "'${BATS_TEST_TMPDIR}/stubs/vim' -c \"stty -icanon -isig -echo; echo re''ady; while :; do dd bs=1 count=1 2>/dev/null | od -An -tx1; done\"" Enter
  wait_for pane_shows %1 ready

  # Act
  press C-h

  # Assert
  wait_for pane_shows %1 ' 08'
}

@test "keys - with vim navigation, prefix C-l sends the clear-screen key to the pane" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  reads_keys %0

  # Act
  press C-b C-l

  # Assert
  wait_for pane_shows %0 ' 0c'
}

@test "keys - with vim navigation, C-h in vi copy mode selects the pane on the left" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux set-option -g mode-keys vi
  tmux split-window -h -t test
  tmux copy-mode -t %1

  # Act
  press C-h

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - with vim navigation, C-j in vi copy mode selects the pane below" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux set-option -g mode-keys vi
  tmux split-window -v -t test
  tmux select-pane -t %0
  tmux copy-mode -t %0

  # Act
  press C-j

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - with vim navigation, C-k in vi copy mode selects the pane above" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux set-option -g mode-keys vi
  tmux split-window -v -t test
  tmux copy-mode -t %1

  # Act
  press C-k

  # Assert
  wait_for shows test: '#{pane_id}' %0
}

@test "keys - with vim navigation, C-l in vi copy mode selects the pane on the right" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux set-option -g mode-keys vi
  tmux split-window -h -t test
  tmux select-pane -t %0
  tmux copy-mode -t %0

  # Act
  press C-l

  # Assert
  wait_for shows test: '#{pane_id}' %1
}

@test "keys - with vim navigation, C-\\ in vi copy mode selects the pane used before" {
  # Arrange
  key vim_navigation on
  load_plugin "${ROOT}"
  tmux set-option -g mode-keys vi
  tmux split-window -h -t test
  tmux split-window -v -t test
  tmux select-pane -t %0
  tmux copy-mode -t %0

  # Act
  press "C-\\"

  # Assert
  wait_for shows test: '#{pane_id}' %2
}
