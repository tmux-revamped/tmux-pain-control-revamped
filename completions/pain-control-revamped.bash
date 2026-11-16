# shellcheck shell=bash
# shellcheck disable=SC2207

_pain_control_revamped() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  case "${prev}" in
  --theme)
    COMPREPLY=($(compgen -W "kodougu catppuccin-mocha catppuccin-latte dracula nord gruvbox tokyo-night mono" -- "${cur}"))
    return
    ;;
  --resize | --new-window-path | --disabled-keys | --no-wrap | --vim-navigation | --vim-pattern | --pane-titles | --sync-key | --smart-split-key | --swap-window-left-key | --swap-window-right-key | --move-window-key | --kill-window-key | --join-key | --break-key | --swap-prev-key | --swap-next-key | --promote-key | --mark-key | --swap-mark-key | --layout-even-h-key | --layout-even-v-key | --layout-main-v-key | --respawn-key | --capture-key | --pane-name-key | --scratch-key | --scratch-command | --zoom-key | --focus-size)
    COMPREPLY=()
    return
    ;;
  *) ;;
  esac

  COMPREPLY=($(compgen -W "apply list zoom doctor version help --json --theme --resize --new-window-path --disabled-keys --no-wrap --vim-navigation --vim-pattern --pane-titles --sync-key --smart-split-key --swap-window-left-key --swap-window-right-key --move-window-key --kill-window-key --join-key --break-key --swap-prev-key --swap-next-key --promote-key --mark-key --swap-mark-key --layout-even-h-key --layout-even-v-key --layout-main-v-key --respawn-key --capture-key --pane-name-key --scratch-key --scratch-command --zoom-key --focus-size" -- "${cur}"))
}

complete -F _pain_control_revamped pain-control-revamped
