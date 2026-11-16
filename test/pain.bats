#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031,SC2034

# shellcheck source=test/helpers.bash
source "${BATS_TEST_DIRNAME:-.}/helpers.bash"

setup() {
  harness_setup
  for name in $(compgen -v PAIN_CONTROL_REVAMPED_); do
    unset "${name}"
  done
}

option() {
  printf '%s' "$2" >"${REVAMPED_TEST_TMUX_DIR}/$(printf '%s' "g.-.@pain_control_revamped_$1" | tr -c 'A-Za-z0-9_.-' '_')"
}

plan_at() {
  export REVAMPED_TEST_TMUX_VERSION="$1"
  lib_run pain 'pain_control_revamped_plan; pain_control_revamped_lines'
}

@test "pain - the version is read from tmux -V, next and rc builds included" {
  # Arrange
  local script='for v in "tmux 3.6" "tmux next-3.7" "tmux 3.5a" "tmux master"; do printf "[%s]\n" "$(pain_control_revamped_parse_version "${v}")"; done'

  # Act
  lib_run pain "${script}"

  # Assert
  [[ "${output}" == $'[3.6]\n[3.7]\n[3.5]\n[]' ]]
}

@test "pain - version_ge compares major and minor numbers" {
  # Arrange
  local script='for pair in "3.2 3.1" "3.1 3.1" "3.0 3.1" "4.0 3.9" "2.9 3.0" "3.10 3.9" " 3.1" "x 3.1"; do set -- ${pair}; if pain_control_revamped_version_ge "${1:-}" "${2:-}"; then printf y; else printf n; fi; done'

  # Act
  lib_run pain "${script}"

  # Assert
  [[ "${output}" == "yynynynn" ]]
}

@test "pain - a key in the disabled list is left alone, commas or spaces" {
  # Arrange
  local script='PAIN_CONTROL_REVAMPED_S_disabled_keys="|, -"; for k in "|" - "%" h; do if pain_control_revamped_disabled "$k"; then printf y; else printf n; fi; done'

  # Act
  lib_run pain "${script}"

  # Assert
  [[ "${output}" == "yynn" ]]
}

@test "pain - a setting comes from the environment, then the tmux option, then its default" {
  # Arrange
  option resize 9
  option join_key J
  export PAIN_CONTROL_REVAMPED_JOIN_KEY=K

  # Act
  lib_run pain 'pain_control_revamped_load; printf "%s %s %s\n" "${PAIN_CONTROL_REVAMPED_S_resize}" "${PAIN_CONTROL_REVAMPED_S_join_key}" "${PAIN_CONTROL_REVAMPED_S_break_key}"'

  # Assert
  [[ "${output}" == "9 K !" ]]
}

@test "pain - an empty tmux option means the default and an empty environment value means none" {
  # Arrange
  option break_key ''
  export PAIN_CONTROL_REVAMPED_JOIN_KEY=

  # Act
  lib_run pain 'pain_control_revamped_load; printf "[%s][%s]\n" "${PAIN_CONTROL_REVAMPED_S_break_key}" "${PAIN_CONTROL_REVAMPED_S_join_key}"'

  # Assert
  [[ "${output}" == "[!][]" ]]
}

@test "pain - the vim pattern keeps its backslashes" {
  # Arrange
  local pattern='(\S+/)?vim'
  option vim_pattern "${pattern}"

  # Act
  lib_run pain 'pain_control_revamped_load; printf "%s\n" "${PAIN_CONTROL_REVAMPED_S_vim_pattern}"'

  # Assert
  [[ "${output}" == '(\S+/)?vim' ]]
}

@test "pain - settings fall back to the defaults when no tmux server answers" {
  # Arrange
  export REVAMPED_TEST_TMUX_FAIL=1

  # Act
  lib_run pain 'pain_control_revamped_load; printf "%s\n" "${PAIN_CONTROL_REVAMPED_S_resize}"'

  # Assert
  [[ "${output}" == "5" ]]
}

@test "pain - tmux 3.6 gets notes, full splits, the top-left promote and the scratch popup" {
  # Arrange
  option scratch_key T

  # Act
  plan_at 3.6

  # Assert
  [[ "${lines[0]}" == "bind-key -N Select pane left h select-pane -L" ]]
  [[ "${output}" == *"bind-key -N Split full width \\ split-window -fh -c #{pane_current_path}"* ]]
  [[ "${output}" == *"bind-key -N Promote pane to main + swap-pane -d -t {top-left}"* ]]
  [[ "${output}" == *"bind-key -N Scratch popup T display-popup -E -d #{pane_current_path} -w 80% -h 80%"* ]]
  [[ "${output}" == *"bind-key -r -N Resize pane left H resize-pane -L 5"* ]]
}

@test "pain - tmux 2.0 gets no notes, no full splits, no marks and promotes to pane 0" {
  # Arrange
  option scratch_key T
  option pane_name_key N

  # Act
  plan_at 2.0

  # Assert
  [[ "${lines[0]}" == "bind-key h select-pane -L" ]]
  [[ "${output}" == *"bind-key \\ split-window -h -c #{pane_current_path}"* ]]
  [[ "${output}" == *"bind-key + swap-pane -d -t 0"* ]]
  [[ "${output}" != *"select-pane -m"* ]]
  [[ "${output}" != *"display-popup"* ]]
  [[ "${output}" != *"select-pane -T"* ]]
}

@test "pain - no-wrap stops navigation at the edge" {
  # Arrange
  option no_wrap on

  # Act
  plan_at 3.6

  # Assert
  [[ "${lines[0]}" == "bind-key -N Select pane left h if-shell -F #{pane_at_left} select-pane select-pane -L" ]]
}

@test "pain - vim navigation sends the chords to vim and clears with C-l" {
  # Arrange
  option vim_navigation on

  # Act
  plan_at 3.6

  # Assert
  [[ "${output}" == *"bind-key -n C-h if-shell ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?\$' send-keys C-h select-pane -L"* ]]
  [[ "${output}" == *"bind-key -n C-\\ if-shell"*"send-keys C-\\\\ select-pane -l"* ]]
  [[ "${output}" == *"bind-key -T copy-mode-vi C-l select-pane -R"* ]]
  [[ "${output}" == *"bind-key -N Clear screen C-l send-keys C-l"* ]]
}

@test "pain - pane titles turn on the border status" {
  # Arrange
  option pane_titles on
  option pane_name_key N

  # Act
  plan_at 3.6

  # Assert
  [[ "${output}" == *"set-option -g pane-border-status top"* ]]
  [[ "${output}" == *"set-option -g pane-border-format  #{pane_index}: #{pane_title} "* ]]
  [[ "${output}" == *"bind-key -N Name pane N command-prompt -p pane title: select-pane -T '%%'"* ]]
}

@test "pain - the optional keys bind only when set" {
  # Arrange
  option sync_key S
  option scratch_key T
  option scratch_command htop
  option swap_window_left_key '<'
  option swap_window_right_key '>'
  option move_window_key M
  option kill_window_key X
  option layout_even_h_key E
  option layout_even_v_key V
  option layout_main_v_key W
  option respawn_key R
  option capture_key P
  option new_window_path off

  # Act
  plan_at 3.6

  # Assert
  [[ "${output}" == *"Toggle pane sync S set-window-option synchronize-panes \\; display-message"* ]]
  [[ "${output}" == *"Scratch popup T display-popup -E -d #{pane_current_path} -w 80% -h 80% htop"* ]]
  [[ "${output}" == *"bind-key -r -N Swap window left < swap-window -d -t -1"* ]]
  [[ "${output}" == *"Even-vertical layout V select-layout even-vertical"* ]]
  [[ "${output}" == *"Capture scrollback to file P command-prompt"* ]]
  [[ "${output}" != *"New window here"* ]]
}

@test "pain - apply sends every binding to tmux in one call" {
  # Arrange
  export REVAMPED_TEST_TMUX_ARGV="${BATS_TEST_TMPDIR}/argv"

  # Act
  lib_run pain pain_control_revamped_apply

  # Assert
  run grep -c '^bind-key' "${REVAMPED_TEST_TMUX_ARGV}"
  [[ "${output}" == "1" ]]
  run grep -c '|;|bind-key|' "${REVAMPED_TEST_TMUX_ARGV}"
  [[ "${output}" == "1" ]]
}

@test "pain - apply calls tmux for nothing when every key is disabled" {
  # Arrange
  option disabled_keys 'h C-h j C-j k C-k l C-l H J K L | - " % \ _ * c @ ! { } + m ='
  export REVAMPED_TEST_TMUX_ARGV="${BATS_TEST_TMPDIR}/argv"

  # Act
  lib_run pain pain_control_revamped_apply

  # Assert
  [[ "${status}" -eq 0 ]]
  run grep -c '^bind-key' "${REVAMPED_TEST_TMUX_ARGV}"
  [[ "${output}" == "0" ]]
}

@test "pain - json lists every binding as its arguments" {
  # Arrange
  option disabled_keys 'C-h j C-j k C-k l C-l H J K L | - " % \ _ * c @ ! { } + m ='

  # Act
  lib_run pain 'pain_control_revamped_plan; pain_control_revamped_json'

  # Assert
  [[ "${output}" == '{"bindings":[["bind-key","-N","Select pane left","h","select-pane","-L"]]}' ]]
}

@test "pain - json escapes quotes and backslashes" {
  # Arrange
  local script='PAIN_CONTROL_REVAMPED_PLAN="$(printf "a\\\\b\nsay \"hi\"\n\n")"; pain_control_revamped_json'

  # Act
  lib_run pain "${script}"

  # Assert
  [[ "${output}" == '{"bindings":[["a\\b","say \"hi\""]]}' ]]
}

@test "pain - bindings counts the bind-key commands" {
  # Arrange
  option pane_titles on

  # Act
  lib_run pain 'pain_control_revamped_plan; pain_control_revamped_bindings'

  # Assert
  [[ "${output}" == "27" ]]
}

@test "pain - a setting name comes from its long option" {
  # Arrange
  local script='for o in --join-key --smart-split-key --colour; do printf "[%s]" "$(pain_control_revamped_setting_name "$o")"; done'

  # Act
  lib_run pain "${script}"

  # Assert
  [[ "${output}" == "[join_key][smart_split_key][]" ]]
}
