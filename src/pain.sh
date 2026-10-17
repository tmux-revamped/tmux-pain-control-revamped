#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=/dev/null
source "${PLUGIN_DIR}/src/lib/pain/pain.sh"

_emit() {
  if [[ -n "${PAIN_DRY_RUN:-}" ]]; then
    echo "$*"
  else
    tmux "$@"
  fi
}

get_opt() {
  local v
  v="$(tmux show-option -gqv "${1}" 2>/dev/null)"
  echo "${v:-${2}}"
}

pain_bind() {
  local flags="${1}" key="${2}" desc="${3}"
  shift 3
  [[ -n "${key}" ]] || return 0
  key_disabled "${key}" "${PAIN_DISABLED}" && return 0
  if [[ "${PAIN_NOTES}" == "1" ]]; then
    # shellcheck disable=SC2086
    _emit bind-key ${flags} -N "${desc}" "${key}" "$@"
  else
    # shellcheck disable=SC2086
    _emit bind-key ${flags} "${key}" "$@"
  fi
}

_path='#{pane_current_path}'

_bind_nav() {
  local key="${1}" desc="${2}" edge="${3}" dirflag="${4}"
  if [[ "${PAIN_NOWRAP}" == "1" ]]; then
    pain_bind "" "${key}" "${desc}" if-shell -F "#{${edge}}" "select-pane" "select-pane ${dirflag}"
  else
    pain_bind "" "${key}" "${desc}" select-pane "${dirflag}"
  fi
}

_apply_vim_nav() {
  local is_vim pattern
  pattern="$(get_opt @pane_control_vim_pattern '(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?')"
  is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +${pattern}\$'"
  _emit bind-key -n C-h if-shell "${is_vim}" "send-keys C-h" "select-pane -L"
  _emit bind-key -n C-j if-shell "${is_vim}" "send-keys C-j" "select-pane -D"
  _emit bind-key -n C-k if-shell "${is_vim}" "send-keys C-k" "select-pane -U"
  _emit bind-key -n C-l if-shell "${is_vim}" "send-keys C-l" "select-pane -R"
  _emit bind-key -n 'C-\' if-shell "${is_vim}" 'send-keys C-\\' 'select-pane -l'
  _emit bind-key -T copy-mode-vi C-h select-pane -L
  _emit bind-key -T copy-mode-vi C-j select-pane -D
  _emit bind-key -T copy-mode-vi C-k select-pane -U
  _emit bind-key -T copy-mode-vi C-l select-pane -R
  _emit bind-key -T copy-mode-vi 'C-\' select-pane -l
}

apply_pain() {
  local ver step npath synckey splitf vmark scratchcmd
  ver="$(tmux_version)"
  step="$(get_opt @pane_resize 5)"
  synckey="$(get_opt @pane_control_sync_key "")"
  npath="$(get_opt @new_window_path true)"
  PAIN_DISABLED="$(get_opt @pane_control_disabled_keys "")"
  PAIN_NOTES=0
  version_ge "${ver}" 3.1 && PAIN_NOTES=1
  splitf=0
  version_ge "${ver}" 2.3 && splitf=1
  vmark=0
  version_ge "${ver}" 2.1 && vmark=1

  PAIN_NOWRAP=0
  if [[ "$(get_opt @pane_control_no_wrap off)" == "on" ]] && version_ge "${ver}" 2.6; then
    PAIN_NOWRAP=1
  fi

  _bind_nav h "Select pane left" pane_at_left -L
  _bind_nav C-h "Select pane left" pane_at_left -L
  _bind_nav j "Select pane below" pane_at_bottom -D
  _bind_nav C-j "Select pane below" pane_at_bottom -D
  _bind_nav k "Select pane above" pane_at_top -U
  _bind_nav C-k "Select pane above" pane_at_top -U
  _bind_nav l "Select pane right" pane_at_right -R
  _bind_nav C-l "Select pane right" pane_at_right -R

  pain_bind "-r" H "Resize pane left" resize-pane -L "${step}"
  pain_bind "-r" J "Resize pane down" resize-pane -D "${step}"
  pain_bind "-r" K "Resize pane up" resize-pane -U "${step}"
  pain_bind "-r" L "Resize pane right" resize-pane -R "${step}"

  pain_bind "" "|" "Split right" split-window -h -c "${_path}"
  pain_bind "" "-" "Split down" split-window -v -c "${_path}"
  pain_bind "" '"' "Split down" split-window -v -c "${_path}"
  pain_bind "" "%" "Split right" split-window -h -c "${_path}"
  if [[ "${splitf}" -eq 1 ]]; then
    pain_bind "" "\\" "Split full width" split-window -fh -c "${_path}"
    pain_bind "" "_" "Split full height" split-window -fv -c "${_path}"
  else
    pain_bind "" "\\" "Split right" split-window -h -c "${_path}"
    pain_bind "" "_" "Split down" split-window -v -c "${_path}"
  fi

  pain_bind "" "$(get_opt @pane_control_smart_split_key '*')" "Smart split" \
    if-shell "[ #{pane_width} -gt #{pane_height} ]" \
    "split-window -h -c ${_path}" "split-window -v -c ${_path}"

  case "${npath}" in
    true|on|1) pain_bind "" c "New window here" new-window -c "${_path}" ;;
  esac

  pain_bind "-r" "$(get_opt @pane_control_swap_window_left_key "")" "Swap window left" swap-window -d -t -1
  pain_bind "-r" "$(get_opt @pane_control_swap_window_right_key "")" "Swap window right" swap-window -d -t +1

  pain_bind "" "$(get_opt @pane_control_move_window_key '')" "Move window to session" \
    command-prompt -p "move window to session:" "move-window -t '%%'"

  pain_bind "" "$(get_opt @pane_control_kill_window_key '')" "Kill window" \
    confirm-before -p "kill-window #W? (y/n)" kill-window

  pain_bind "" "$(get_opt @pane_control_join_key '@')" "Join pane" \
    command-prompt -p "join pane from:" "join-pane -h -s '%%'"
  pain_bind "" "$(get_opt @pane_control_break_key '!')" "Break pane to window" break-pane

  pain_bind "-r" "$(get_opt @pane_control_swap_prev_key '{')" "Swap pane up" swap-pane -U
  pain_bind "-r" "$(get_opt @pane_control_swap_next_key '}')" "Swap pane down" swap-pane -D
  if version_ge "${ver}" 3.0; then
    pain_bind "" "$(get_opt @pane_control_promote_key '+')" "Promote pane to main" \
      swap-pane -d -t '{top-left}'
  else
    pain_bind "" "$(get_opt @pane_control_promote_key '+')" "Promote pane to main" \
      swap-pane -d -t 0
  fi

  if [[ "${vmark}" -eq 1 ]]; then
    pain_bind "" "$(get_opt @pane_control_mark_key m)" "Mark pane" select-pane -m
    pain_bind "" "$(get_opt @pane_control_swap_mark_key '=')" "Swap with marked pane" swap-pane
  fi

  pain_bind "" "$(get_opt @pane_control_layout_even_h_key '')" "Even-horizontal layout" \
    select-layout even-horizontal
  pain_bind "" "$(get_opt @pane_control_layout_even_v_key '')" "Even-vertical layout" \
    select-layout even-vertical
  pain_bind "" "$(get_opt @pane_control_layout_main_v_key '')" "Main-vertical layout" \
    select-layout main-vertical

  pain_bind "" "$(get_opt @pane_control_respawn_key '')" "Respawn pane" \
    confirm-before -p "respawn-pane? (y/n)" "respawn-pane -k"

  pain_bind "" "$(get_opt @pane_control_capture_key '')" "Capture scrollback to file" \
    command-prompt -p "save scrollback to:" -I "${HOME}/tmux-scrollback.log" \
    "capture-pane -S - ; save-buffer '%%' ; delete-buffer"

  if version_ge "${ver}" 2.6; then
    pain_bind "" "$(get_opt @pane_control_pane_name_key '')" "Name pane" \
      command-prompt -p "pane title:" "select-pane -T '%%'"
  fi

  if [[ "$(get_opt @pane_control_pane_titles off)" == "on" ]] && version_ge "${ver}" 2.3; then
    _emit set-option -g pane-border-status top
    _emit set-option -g pane-border-format " #{pane_index}: #{pane_title} "
  fi

  if version_ge "${ver}" 3.2; then
    scratchcmd="$(get_opt @pane_control_scratch_command "")"
    if [[ -n "${scratchcmd}" ]]; then
      pain_bind "" "$(get_opt @pane_control_scratch_key '')" "Scratch popup" \
        display-popup -E -d "${_path}" -w 80% -h 80% "${scratchcmd}"
    else
      pain_bind "" "$(get_opt @pane_control_scratch_key '')" "Scratch popup" \
        display-popup -E -d "${_path}" -w 80% -h 80%
    fi
  fi

  pain_bind "" "${synckey}" "Toggle pane sync" set-window-option synchronize-panes "\;" display-message "synchronize-panes #{?synchronize-panes,on,off}"

  if [[ "$(get_opt @pane_control_vim_navigation off)" == "on" ]] && version_ge "${ver}" 2.4; then
    _apply_vim_nav
    pain_bind "" C-l "Clear screen" send-keys C-l
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  apply_pain
fi
