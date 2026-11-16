#!/bin/sh

[ -n "${PAIN_CONTROL_REVAMPED_PAIN_LOADED:-}" ] && return 0
PAIN_CONTROL_REVAMPED_PAIN_LOADED=1

# shellcheck source=SCRIPTDIR/state.sh
. "${REVAMPED_LIB:?}/state.sh"

pain_control_revamped_format() {
  printf '%s\n' "${PAIN_CONTROL_REVAMPED_SETTINGS}" | awk -F '\t' '{ printf "%s#{@pain_control_revamped_%s}", (NR > 1 ? "\t" : ""), $1 }'
}

pain_control_revamped_resolve() {
  env | PAIN_CONTROL_REVAMPED_ROWS="${PAIN_CONTROL_REVAMPED_SETTINGS}" PAIN_CONTROL_REVAMPED_LIVE="$1" awk '
    BEGIN {
      count = split(ENVIRON["PAIN_CONTROL_REVAMPED_ROWS"], rows, "\n")
      split(ENVIRON["PAIN_CONTROL_REVAMPED_LIVE"], live, "\t")
      for (i = 1; i <= count; i++) {
        split(rows[i], field, "\t")
        name[i] = field[1]
        value[i] = (live[i] != "") ? live[i] : field[2]
        want["PAIN_CONTROL_REVAMPED_" toupper(field[1])] = i
      }
    }
    {
      at = index($0, "=")
      key = substr($0, 1, at - 1)
      if (key in want) { value[want[key]] = substr($0, at + 1) }
    }
    END { for (i = 1; i <= count; i++) { print name[i] "\t" value[i] } }
  '
}

pain_control_revamped_load() {
  pain_control_revamped_load_format=$(pain_control_revamped_format)
  pain_control_revamped_load_live=$(tmux display-message -p "${pain_control_revamped_load_format}" 2>/dev/null) || pain_control_revamped_load_live=""
  pain_control_revamped_load_values=$(pain_control_revamped_resolve "${pain_control_revamped_load_live}")
  while IFS='	' read -r pain_control_revamped_load_name pain_control_revamped_load_value; do
    IFS= read -r "PAIN_CONTROL_REVAMPED_S_${pain_control_revamped_load_name}" <<EOF
${pain_control_revamped_load_value}
EOF
  done <<EOF
${pain_control_revamped_load_values}
EOF
}

pain_control_revamped_parse_version() {
  printf '%s\n' "$1" | sed -En 's/^tmux[ -]([a-z]+-)?([0-9]+\.[0-9]+).*/\2/p'
}

pain_control_revamped_version_ge() {
  case "$1:$2" in
  *[!0-9.:]* | :* | *:) return 1 ;;
  *) ;;
  esac
  pain_control_revamped_version_ge_have_major="${1%%.*}"
  pain_control_revamped_version_ge_want_major="${2%%.*}"
  pain_control_revamped_version_ge_have_minor="${1#"${pain_control_revamped_version_ge_have_major}"}"
  pain_control_revamped_version_ge_have_minor="${pain_control_revamped_version_ge_have_minor#.}"
  pain_control_revamped_version_ge_want_minor="${2#"${pain_control_revamped_version_ge_want_major}"}"
  pain_control_revamped_version_ge_want_minor="${pain_control_revamped_version_ge_want_minor#.}"
  [ "${pain_control_revamped_version_ge_have_major}" -gt "${pain_control_revamped_version_ge_want_major}" ] && return 0
  [ "${pain_control_revamped_version_ge_have_major}" -eq "${pain_control_revamped_version_ge_want_major}" ] || return 1
  [ "${pain_control_revamped_version_ge_have_minor%%.*}" -ge "${pain_control_revamped_version_ge_want_minor%%.*}" ]
}

pain_control_revamped_at_least() {
  pain_control_revamped_version_ge "${PAIN_CONTROL_REVAMPED_TMUX}" "$1"
}

pain_control_revamped_disabled() {
  pain_control_revamped_disabled_list=" ${PAIN_CONTROL_REVAMPED_S_disabled_keys} "
  pain_control_revamped_disabled_list=$(printf '%s\n' "${pain_control_revamped_disabled_list}" | tr ',' ' ')
  case "${pain_control_revamped_disabled_list}" in
  *" $1 "*) return 0 ;;
  *) return 1 ;;
  esac
}

pain_control_revamped_emit() {
  for pain_control_revamped_emit_arg in "$@"; do
    PAIN_CONTROL_REVAMPED_PLAN="${PAIN_CONTROL_REVAMPED_PLAN}${pain_control_revamped_emit_arg}
"
  done
  PAIN_CONTROL_REVAMPED_PLAN="${PAIN_CONTROL_REVAMPED_PLAN}
"
}

pain_control_revamped_bind() {
  [ -n "$2" ] || return 0
  ! pain_control_revamped_disabled "$2" || return 0
  pain_control_revamped_bind_flags="$1"
  pain_control_revamped_bind_desc="$3"
  pain_control_revamped_bind_key="$2"
  shift 3
  set -- "${pain_control_revamped_bind_key}" "$@"
  [ "${PAIN_CONTROL_REVAMPED_NOTES}" != 1 ] || set -- -N "${pain_control_revamped_bind_desc}" "$@"
  [ -z "${pain_control_revamped_bind_flags}" ] || set -- "${pain_control_revamped_bind_flags}" "$@"
  pain_control_revamped_emit bind-key "$@"
}

pain_control_revamped_nav() {
  if [ "${PAIN_CONTROL_REVAMPED_NOWRAP}" = 1 ]; then
    pain_control_revamped_bind "" "$1" "$2" if-shell -F "#{$3}" "select-pane" "select-pane $4"
    return 0
  fi
  pain_control_revamped_bind "" "$1" "$2" select-pane "$4"
}

pain_control_revamped_plan_panes() {
  pain_control_revamped_nav h "Select pane left" pane_at_left -L
  pain_control_revamped_nav C-h "Select pane left" pane_at_left -L
  pain_control_revamped_nav j "Select pane below" pane_at_bottom -D
  pain_control_revamped_nav C-j "Select pane below" pane_at_bottom -D
  pain_control_revamped_nav k "Select pane above" pane_at_top -U
  pain_control_revamped_nav C-k "Select pane above" pane_at_top -U
  pain_control_revamped_nav l "Select pane right" pane_at_right -R
  pain_control_revamped_nav C-l "Select pane right" pane_at_right -R
  pain_control_revamped_bind -r H "Resize pane left" resize-pane -L "${PAIN_CONTROL_REVAMPED_S_resize}"
  pain_control_revamped_bind -r J "Resize pane down" resize-pane -D "${PAIN_CONTROL_REVAMPED_S_resize}"
  pain_control_revamped_bind -r K "Resize pane up" resize-pane -U "${PAIN_CONTROL_REVAMPED_S_resize}"
  pain_control_revamped_bind -r L "Resize pane right" resize-pane -R "${PAIN_CONTROL_REVAMPED_S_resize}"
}

pain_control_revamped_plan_splits() {
  pain_control_revamped_plan_splits_path="${PAIN_CONTROL_REVAMPED_PATH}"
  pain_control_revamped_bind "" "|" "Split right" split-window -h -c "${pain_control_revamped_plan_splits_path}"
  pain_control_revamped_bind "" "-" "Split down" split-window -v -c "${pain_control_revamped_plan_splits_path}"
  pain_control_revamped_bind "" '"' "Split down" split-window -v -c "${pain_control_revamped_plan_splits_path}"
  pain_control_revamped_bind "" "%" "Split right" split-window -h -c "${pain_control_revamped_plan_splits_path}"
  if pain_control_revamped_at_least 2.3; then
    pain_control_revamped_bind "" "\\" "Split full width" split-window -fh -c "${pain_control_revamped_plan_splits_path}"
    pain_control_revamped_bind "" "_" "Split full height" split-window -fv -c "${pain_control_revamped_plan_splits_path}"
  else
    pain_control_revamped_bind "" "\\" "Split right" split-window -h -c "${pain_control_revamped_plan_splits_path}"
    pain_control_revamped_bind "" "_" "Split down" split-window -v -c "${pain_control_revamped_plan_splits_path}"
  fi
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_smart_split_key}" "Smart split" \
    if-shell "[ #{pane_width} -gt #{pane_height} ]" \
    "split-window -h -c ${pain_control_revamped_plan_splits_path}" "split-window -v -c ${pain_control_revamped_plan_splits_path}"
  case "${PAIN_CONTROL_REVAMPED_S_new_window_path}" in
  true | on | 1) pain_control_revamped_bind "" c "New window here" new-window -c "${pain_control_revamped_plan_splits_path}" ;;
  *) : ;;
  esac
}

pain_control_revamped_plan_windows() {
  pain_control_revamped_bind -r "${PAIN_CONTROL_REVAMPED_S_swap_window_left_key}" "Swap window left" swap-window -d -t -1
  pain_control_revamped_bind -r "${PAIN_CONTROL_REVAMPED_S_swap_window_right_key}" "Swap window right" swap-window -d -t +1
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_move_window_key}" "Move window to session" \
    command-prompt -p "move window to session:" "move-window -t '%%'"
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_kill_window_key}" "Kill window" \
    confirm-before -p "kill-window #W? (y/n)" kill-window
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_join_key}" "Join pane" \
    command-prompt -p "join pane from:" "join-pane -h -s '%%'"
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_break_key}" "Break pane to window" break-pane
  pain_control_revamped_bind -r "${PAIN_CONTROL_REVAMPED_S_swap_prev_key}" "Swap pane up" swap-pane -U
  pain_control_revamped_bind -r "${PAIN_CONTROL_REVAMPED_S_swap_next_key}" "Swap pane down" swap-pane -D
  pain_control_revamped_plan_windows_target=0
  ! pain_control_revamped_at_least 3.0 || pain_control_revamped_plan_windows_target='{top-left}'
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_promote_key}" "Promote pane to main" \
    swap-pane -d -t "${pain_control_revamped_plan_windows_target}"
  if pain_control_revamped_at_least 2.1; then
    pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_mark_key}" "Mark pane" select-pane -m
    pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_swap_mark_key}" "Swap with marked pane" swap-pane
  fi
}

pain_control_revamped_plan_layouts() {
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_layout_even_h_key}" "Even-horizontal layout" select-layout even-horizontal
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_layout_even_v_key}" "Even-vertical layout" select-layout even-vertical
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_layout_main_v_key}" "Main-vertical layout" select-layout main-vertical
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_respawn_key}" "Respawn pane" \
    confirm-before -p "respawn-pane? (y/n)" "respawn-pane -k"
  pain_control_revamped_plan_layouts_file="${HOME}/tmux-scrollback.log"
  pain_control_revamped_plan_layouts_save="capture-pane -S - ; save-buffer '%%' ; delete-buffer"
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_capture_key}" "Capture scrollback to file" command-prompt -p "save scrollback to:" -I "${pain_control_revamped_plan_layouts_file}" "${pain_control_revamped_plan_layouts_save}"
  if pain_control_revamped_at_least 2.6; then
    pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_pane_name_key}" "Name pane" \
      command-prompt -p "pane title:" "select-pane -T '%%'"
  fi
  if [ "${PAIN_CONTROL_REVAMPED_S_pane_titles}" = on ] && pain_control_revamped_at_least 2.3; then
    pain_control_revamped_emit set-option -g pane-border-status top
    pain_control_revamped_emit set-option -g pane-border-format " #{pane_index}: #{pane_title} "
  fi
}

pain_control_revamped_plan_extras() {
  if pain_control_revamped_at_least 3.2; then
    set -- display-popup -E -d "${PAIN_CONTROL_REVAMPED_PATH}" -w 80% -h 80%
    [ -z "${PAIN_CONTROL_REVAMPED_S_scratch_command}" ] || set -- "$@" "${PAIN_CONTROL_REVAMPED_S_scratch_command}"
    pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_scratch_key}" "Scratch popup" "$@"
  fi
  pain_control_revamped_plan_extras_then='\;'
  pain_control_revamped_plan_extras_say="synchronize-panes #{?synchronize-panes,on,off}"
  pain_control_revamped_bind "" "${PAIN_CONTROL_REVAMPED_S_sync_key}" "Toggle pane sync" set-window-option synchronize-panes "${pain_control_revamped_plan_extras_then}" display-message "${pain_control_revamped_plan_extras_say}"
  if [ "${PAIN_CONTROL_REVAMPED_S_vim_navigation}" = on ] && pain_control_revamped_at_least 2.4; then
    pain_control_revamped_plan_vim
    pain_control_revamped_bind "" C-l "Clear screen" send-keys C-l
  fi
}

pain_control_revamped_plan_vim() {
  pain_control_revamped_plan_vim_test="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +${PAIN_CONTROL_REVAMPED_S_vim_pattern}\$'"
  pain_control_revamped_emit bind-key -n C-h if-shell "${pain_control_revamped_plan_vim_test}" "send-keys C-h" "select-pane -L"
  pain_control_revamped_emit bind-key -n C-j if-shell "${pain_control_revamped_plan_vim_test}" "send-keys C-j" "select-pane -D"
  pain_control_revamped_emit bind-key -n C-k if-shell "${pain_control_revamped_plan_vim_test}" "send-keys C-k" "select-pane -U"
  pain_control_revamped_emit bind-key -n C-l if-shell "${pain_control_revamped_plan_vim_test}" "send-keys C-l" "select-pane -R"
  pain_control_revamped_emit bind-key -n "C-\\" if-shell "${pain_control_revamped_plan_vim_test}" "send-keys C-\\\\" "select-pane -l"
  pain_control_revamped_emit bind-key -T copy-mode-vi C-h select-pane -L
  pain_control_revamped_emit bind-key -T copy-mode-vi C-j select-pane -D
  pain_control_revamped_emit bind-key -T copy-mode-vi C-k select-pane -U
  pain_control_revamped_emit bind-key -T copy-mode-vi C-l select-pane -R
  pain_control_revamped_emit bind-key -T copy-mode-vi "C-\\" select-pane -l
}

pain_control_revamped_plan() {
  pain_control_revamped_load
  pain_control_revamped_plan_raw=$(tmux -V 2>/dev/null) || pain_control_revamped_plan_raw=""
  PAIN_CONTROL_REVAMPED_TMUX=$(pain_control_revamped_parse_version "${pain_control_revamped_plan_raw}")
  PAIN_CONTROL_REVAMPED_NOTES=0
  ! pain_control_revamped_at_least 3.1 || PAIN_CONTROL_REVAMPED_NOTES=1
  PAIN_CONTROL_REVAMPED_NOWRAP=0
  if [ "${PAIN_CONTROL_REVAMPED_S_no_wrap}" = on ] && pain_control_revamped_at_least 2.6; then
    PAIN_CONTROL_REVAMPED_NOWRAP=1
  fi
  PAIN_CONTROL_REVAMPED_PLAN=""
  pain_control_revamped_plan_panes
  pain_control_revamped_plan_splits
  pain_control_revamped_plan_windows
  pain_control_revamped_plan_layouts
  pain_control_revamped_plan_extras
}

pain_control_revamped_apply() {
  pain_control_revamped_plan
  set --
  while IFS= read -r pain_control_revamped_apply_line; do
    if [ -n "${pain_control_revamped_apply_line}" ]; then
      set -- "$@" "${pain_control_revamped_apply_line}"
    elif [ "$#" -gt 0 ]; then
      set -- "$@" ";"
    fi
  done <<PLAN
${PAIN_CONTROL_REVAMPED_PLAN}
PLAN
  [ "$#" -gt 0 ] || return 0
  tmux "$@"
}

pain_control_revamped_lines() {
  printf '%s' "${PAIN_CONTROL_REVAMPED_PLAN}" | awk 'NF == 0 && line != "" { print line; line = ""; next } NF == 0 { next } { line = (line == "" ? $0 : line " " $0) } END { if (line != "") { print line } }'
}

pain_control_revamped_json() {
  printf '%s' "${PAIN_CONTROL_REVAMPED_PLAN}" | awk '
    function quote(s,    out, i, c) {
      out = ""
      for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        if (c == "\\") { out = out "\\\\" } else if (c == "\"") { out = out "\\\"" } else { out = out c }
      }
      return "\"" out "\""
    }
    /^$/ { if (args != "") { rows = rows (rows == "" ? "" : ",") "[" args "]" } args = ""; next }
    { args = args (args == "" ? "" : ",") quote($0) }
    END {
      if (args != "") { rows = rows (rows == "" ? "" : ",") "[" args "]" }
      print "{\"bindings\":[" rows "]}"
    }
  '
}

pain_control_revamped_bindings() {
  printf '%s' "${PAIN_CONTROL_REVAMPED_PLAN}" | awk 'previous == "" && $0 == "bind-key" { count++ } { previous = $0 } END { print count + 0 }'
}

pain_control_revamped_setting_name() {
  pain_control_revamped_setting_name_raw=$(printf '%s\n' "${1#--}" | tr '-' '_')
  case " ${PAIN_CONTROL_REVAMPED_NAMES} " in
  *" ${pain_control_revamped_setting_name_raw} "*) printf '%s\n' "${pain_control_revamped_setting_name_raw}" ;;
  *) printf '\n' ;;
  esac
}
