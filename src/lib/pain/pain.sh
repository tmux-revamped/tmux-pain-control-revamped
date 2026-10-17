#!/usr/bin/env bash
#
# pain.sh: pure decision helpers for tmux-pain-control-revamped.
#
# Version parsing and the disabled-key check are pure. The running tmux version
# sits behind a seam the tests override, so the binding decisions are validated
# without a live tmux.

[[ -n "${_PAIN_REVAMPED_LOADED:-}" ]] && return 0
_PAIN_REVAMPED_LOADED=1

# parse_tmux_version TEXT -> major.minor from `tmux -V`, handling 3.4a and next-3.5.
parse_tmux_version() {
  printf '%s\n' "${1}" | sed -En 's/^tmux[ -]([a-z]+-)?([0-9]+\.[0-9]+).*/\2/p'
}

# version_ge HAVE WANT -> 0 when HAVE is greater than or equal to WANT.
version_ge() {
  [[ -n "${1}" && -n "${2}" ]] || return 1
  local have_major="${1%%.*}" want_major="${2%%.*}" have_minor want_minor
  have_minor="${1#"${have_major}"}"
  have_minor="${have_minor#.}"
  have_minor="${have_minor%%.*}"
  want_minor="${2#"${want_major}"}"
  want_minor="${want_minor#.}"
  want_minor="${want_minor%%.*}"
  have_minor="${have_minor:-0}"
  want_minor="${want_minor:-0}"
  [[ -n "${have_major}" && -n "${want_major}" ]] || return 1
  case "${have_major}${want_major}${have_minor}${want_minor}" in
    *[!0-9]*) return 1 ;;
  esac
  ((10#${have_major} > 10#${want_major})) && return 0
  ((10#${have_major} == 10#${want_major} && 10#${have_minor} >= 10#${want_minor}))
}

# key_disabled KEY LIST -> 0 when KEY appears in the space or comma separated LIST.
key_disabled() {
  local key="${1}" item
  local -a items=()
  IFS=', ' read -r -a items <<<"${2}"
  for item in ${items[@]+"${items[@]}"}; do
    [[ "${item}" == "${key}" ]] && return 0
  done
  return 1
}

# Host-probe seams. Tests override these.
_tmux_version_string() { tmux -V 2>/dev/null; }

tmux_version() { parse_tmux_version "$(_tmux_version_string)"; }

export -f parse_tmux_version
export -f version_ge
export -f key_disabled
export -f _tmux_version_string
export -f tmux_version
