#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034,SC2154

# shellcheck source=test/tmux_helpers.bash
source "${BATS_TEST_DIRNAME:-.}/tmux_helpers.bash"

bats_require_minimum_version 1.5.0

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
