// THIS IS A TIANGUAN MODULE FILE
// 模块：admin_countdown（音乐预传输与连播调度，复用 _shared/audio_helpers.dm）

#define TIANGUAN_CD_TRANSFER_WINDOW 0.75

/datum/tianguan_countdown/proc/music_begin(seconds)
	var/effective = max(round(seconds), 0)
	if(!effective)
		music_duration = total_seconds ? total_seconds : 60
		if(music_from_end && state == TIANGUAN_CD_RUNNING)
			music_deadline = running_deadline
		else
			music_deadline = world.time + max(total_seconds * 10, 10)
	else
		music_duration = effective
		var/span = effective * 10
		if(music_from_end && state == TIANGUAN_CD_RUNNING)
			music_deadline = max(running_deadline - span, world.time)
		else
			music_deadline = world.time + span
	music_remaining = max(music_deadline - world.time, 0)
	music_state = TIANGUAN_CD_RUNNING
	music_begin_transfer()
	start_ticking()
	refresh_all()

/datum/tianguan_countdown/proc/begin_music(seconds)
	music_begin(seconds)

/datum/tianguan_countdown/proc/stop_music()
	music_state = TIANGUAN_CD_IDLE
	music_remaining = 0
	music_deadline = 0
	music_cleanup_transfer()
	music_cleanup_playback()

/datum/tianguan_countdown/proc/music_interval_seconds()
	if(music_rate_manual > 0)
		return music_rate_manual
	var/deadline = (state == TIANGUAN_CD_RUNNING) ? running_deadline : music_deadline
	var/seconds_left = max(round((deadline - world.time) / 10), 1)
	return max((seconds_left * TIANGUAN_CD_TRANSFER_WINDOW) / max(length(music_transfer_queue), 1), 1)

/datum/tianguan_countdown/proc/music_begin_transfer()
	music_cleanup_transfer()
	music_cleanup_playback()
	music_pushed_total = 0
	music_status = list()
	music_transfer_queue = list()
	if(!length(music_selection))
		return
	music_register_online_players()
	music_push_tick()

/datum/tianguan_countdown/proc/music_register_online_players()
	var/track_count = length(music_selection)
	for(var/client/player as anything in GLOB.clients)
		if(QDELETED(player))
			continue
		var/key = player.ckey
		if(music_status[key])
			continue
		music_status[key] = list("name" = player.key, "pushed" = 0, "ready" = FALSE, "left" = FALSE)
		for(var/song_index in 1 to track_count)
			music_transfer_queue += list(list(key, song_index))

/datum/tianguan_countdown/proc/music_push_tick()
	if(state != TIANGUAN_CD_RUNNING && music_state != TIANGUAN_CD_RUNNING)
		return
	if(!length(music_transfer_queue))
		return
	var/list/pair = music_transfer_queue[1]
	music_transfer_queue.Cut(1, 2)
	var/key = pair[1]
	var/list/status = music_status[key]
	var/client/player = GLOB.directory[key]
	if(status && !QDELETED(player))
		if(tianguan_jukebox_send_asset(player, music_selection[pair[2]]))
			status["pushed"]++
			music_pushed_total++
			if(status["pushed"] >= length(music_selection))
				status["ready"] = TRUE
	else if(status)
		status["left"] = TRUE
	music_push_next_schedule()

/datum/tianguan_countdown/proc/music_push_next_schedule()
	if(state != TIANGUAN_CD_RUNNING && music_state != TIANGUAN_CD_RUNNING)
		return
	var/interval = music_interval_seconds()
	music_transfer_timer = addtimer(CALLBACK(src, PROC_REF(music_push_tick)), max(round(interval * 10), 10), TIMER_STOPPABLE)

/datum/tianguan_countdown/proc/music_cleanup_transfer()
	if(music_transfer_timer)
		deltimer(music_transfer_timer)
		music_transfer_timer = null
	music_transfer_queue = list()

/datum/tianguan_countdown/proc/music_play()
	music_cleanup_playback()
	music_play_index = 0
	music_play_next()

/datum/tianguan_countdown/proc/music_play_next()
	music_play_index++
	if(music_play_index > length(music_selection))
		return
	var/track_file = music_selection[music_play_index]
	var/list/report = tianguan_jukebox_broadcast(track_file, music_volume)
	if(!report)
		return
	var/list/track = report["track"]
	log_admin("天关倒计时：播放预传输曲目 [track["name"]]（第 [music_play_index] 首）。")

	if(music_play_index < length(music_selection))
		var/length_ds = max(round(tianguan_jukebox_track_length(track_file) || 0), 0)
		if(!length_ds)
			length_ds = 30 SECONDS
		music_play_timer = addtimer(CALLBACK(src, PROC_REF(music_play_next)), length_ds, TIMER_STOPPABLE)

/datum/tianguan_countdown/proc/music_cleanup_playback()
	if(music_play_timer)
		deltimer(music_play_timer)
		music_play_timer = null
	tianguan_jukebox_stop_broadcast()

/datum/tianguan_countdown/proc/music_status_table()
	return tianguan_transfer_status_table(music_status, length(music_selection))

// ───────────────────────── 传输详情窗口（TGUI：TianGuanCountdownTransfer） ─────────────────────────

/client/var/datum/tianguan_countdown_transfer_ui/tianguan_countdown_transfer_ui

/datum/tianguan_countdown_transfer_ui
	parent_type = /datum/tianguan_admin_ui
	interface_name = "TianGuanCountdownTransfer"

/datum/tianguan_countdown_transfer_ui/New(user)
	..()
	if(holder)
		holder.tianguan_countdown_transfer_ui = src

/datum/tianguan_countdown_transfer_ui/get_active_ui_list()
	return GLOB.tianguan_countdown_transfer_uis

/datum/tianguan_countdown_transfer_ui/clear_client_reference()
	if(holder && holder.tianguan_countdown_transfer_ui == src)
		holder.tianguan_countdown_transfer_ui = null

/datum/tianguan_countdown_transfer_ui/ui_data(mob/user)
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	return list(
		"state" = countdown.state,
		"remaining" = countdown.remaining / 10,
		"silent" = countdown.silent,
		"music_interval" = countdown.music_interval_seconds(),
		"rate_manual" = countdown.music_rate_manual,
		"selection_count" = length(countdown.music_selection),
		"queue_left" = length(countdown.music_transfer_queue),
		"status" = countdown.music_status_table(),
	)

#undef TIANGUAN_CD_TRANSFER_WINDOW
