#!/bin/sh
# shellcheck disable=SC2034

[ -n "${PAIN_CONTROL_REVAMPED_STATE_LOADED:-}" ] && return 0
PAIN_CONTROL_REVAMPED_STATE_LOADED=1

PAIN_CONTROL_REVAMPED_SETTINGS='resize	5
new_window_path	true
disabled_keys	
no_wrap	off
vim_navigation	off
vim_pattern	(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?
pane_titles	off
sync_key	
smart_split_key	*
swap_window_left_key	
swap_window_right_key	
move_window_key	
kill_window_key	
join_key	@
break_key	!
swap_prev_key	{
swap_next_key	}
promote_key	+
mark_key	m
swap_mark_key	=
layout_even_h_key	
layout_even_v_key	
layout_main_v_key	
respawn_key	
capture_key	
pane_name_key	
scratch_key	
scratch_command	
zoom_key	
focus_size	'
PAIN_CONTROL_REVAMPED_NAMES='resize new_window_path disabled_keys no_wrap vim_navigation vim_pattern pane_titles sync_key smart_split_key swap_window_left_key swap_window_right_key move_window_key kill_window_key join_key break_key swap_prev_key swap_next_key promote_key mark_key swap_mark_key layout_even_h_key layout_even_v_key layout_main_v_key respawn_key capture_key pane_name_key scratch_key scratch_command zoom_key focus_size'
PAIN_CONTROL_REVAMPED_S_resize='5'
PAIN_CONTROL_REVAMPED_S_new_window_path='true'
PAIN_CONTROL_REVAMPED_S_disabled_keys=''
PAIN_CONTROL_REVAMPED_S_no_wrap='off'
PAIN_CONTROL_REVAMPED_S_vim_navigation='off'
PAIN_CONTROL_REVAMPED_S_vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
PAIN_CONTROL_REVAMPED_S_pane_titles='off'
PAIN_CONTROL_REVAMPED_S_sync_key=''
PAIN_CONTROL_REVAMPED_S_smart_split_key='*'
PAIN_CONTROL_REVAMPED_S_swap_window_left_key=''
PAIN_CONTROL_REVAMPED_S_swap_window_right_key=''
PAIN_CONTROL_REVAMPED_S_move_window_key=''
PAIN_CONTROL_REVAMPED_S_kill_window_key=''
PAIN_CONTROL_REVAMPED_S_join_key='@'
PAIN_CONTROL_REVAMPED_S_break_key='!'
PAIN_CONTROL_REVAMPED_S_swap_prev_key='{'
PAIN_CONTROL_REVAMPED_S_swap_next_key='}'
PAIN_CONTROL_REVAMPED_S_promote_key='+'
PAIN_CONTROL_REVAMPED_S_mark_key='m'
PAIN_CONTROL_REVAMPED_S_swap_mark_key='='
PAIN_CONTROL_REVAMPED_S_layout_even_h_key=''
PAIN_CONTROL_REVAMPED_S_layout_even_v_key=''
PAIN_CONTROL_REVAMPED_S_layout_main_v_key=''
PAIN_CONTROL_REVAMPED_S_respawn_key=''
PAIN_CONTROL_REVAMPED_S_capture_key=''
PAIN_CONTROL_REVAMPED_S_pane_name_key=''
PAIN_CONTROL_REVAMPED_S_scratch_key=''
PAIN_CONTROL_REVAMPED_S_scratch_command=''
PAIN_CONTROL_REVAMPED_S_zoom_key=''
PAIN_CONTROL_REVAMPED_S_focus_size=''
PAIN_CONTROL_REVAMPED_HOOK_SLOT=37
PAIN_CONTROL_REVAMPED_ZOOM_OF=@pain_control_revamped_zoom_of
PAIN_CONTROL_REVAMPED_ZOOM_HOLD=@pain_control_revamped_zoom_hold
PAIN_CONTROL_REVAMPED_PLAN=""
PAIN_CONTROL_REVAMPED_TMUX=""
PAIN_CONTROL_REVAMPED_NOTES=0
PAIN_CONTROL_REVAMPED_NOWRAP=0
PAIN_CONTROL_REVAMPED_PATH='#{pane_current_path}'
REVAMPED_LOG_NS=pain-control-revamped
