// THIS IS A TIANGUAN MODULE FILE
// 模块：admin_sound_board —— 管理员「全局音效面板」（复用 _shared/audio_helpers.dm & _shared/client_ui.dm）

#define TIANGUAN_SOUND_BOARD_DEFAULT_INTERVAL 1

GLOBAL_LIST_EMPTY(tianguan_sound_board_uis)
GLOBAL_LIST_EMPTY(tianguan_sound_board_transfer_uis)

/datum/tianguan_sound_board
	var/list/status = list()
	var/list/queue = list()
	var/pushed_total = 0
	var/interval = TIANGUAN_SOUND_BOARD_DEFAULT_INTERVAL
	var/volume = 60
	var/push_timer
	var/tick_timer
	var/playing_file
	var/play_end_timer
	var/list/known_files = list()
	var/list/enabled_files = list()
	var/seeded = FALSE

/datum/tianguan_sound_board/Destroy()
	stop_ticking()
	if(push_timer)
		deltimer(push_timer)
		push_timer = null
	if(play_end_timer)
		deltimer(play_end_timer)
		play_end_timer = null
	return ..()

/proc/tianguan_sound_board_controller()
	RETURN_TYPE(/datum/tianguan_sound_board)
	var/static/datum/tianguan_sound_board/board
	if(!board)
		board = new
	return board

/datum/tianguan_sound_board/proc/register_clients()
	var/list/files = tianguan_jukebox_catalog()
	if(!seeded)
		seeded = TRUE
		known_files = files.Copy()
	for(var/client/player as anything in GLOB.clients)
		if(QDELETED(player))
			continue
		var/key = player.ckey
		if(status[key])
			continue
		status[key] = list("name" = player.key, "pushed" = 0, "ready" = FALSE, "left" = FALSE)
		for(var/track_file in enabled_files)
			queue += list(list(key, track_file))
	for(var/track_file in files)
		if(!known_files[track_file])
			enabled_files[track_file] = TRUE
			for(var/other_key in status)
				queue += list(list(other_key, track_file))
	known_files = files.Copy()
	for(var/stale_file in enabled_files.Copy())
		if(!files[stale_file])
			enabled_files -= stale_file
			tianguan_prune_transfer_queue(queue, stale_file)
	if(length(queue) && !push_timer)
		push_now()

/datum/tianguan_sound_board/proc/push_now()
	push_timer = null
	push_one()
	if(length(queue))
		push_timer = addtimer(CALLBACK(src, PROC_REF(push_now)), max(round(interval * 10), 5), TIMER_STOPPABLE)

/datum/tianguan_sound_board/proc/push_one()
	if(!length(queue))
		if(push_timer)
			deltimer(push_timer)
			push_timer = null
		return
	var/list/pair = queue[1]
	queue.Cut(1, 2)
	var/key = pair[1]
	var/track_file = pair[2]
	var/list/entry = status[key]
	var/client/player = GLOB.directory[key]
	if(!entry)
		return
	if(QDELETED(player))
		entry["left"] = TRUE
		return
	if(tianguan_jukebox_send_asset(player, track_file))
		entry["pushed"]++
		pushed_total++
		if(!entry["files"])
			entry["files"] = list()
		entry["files"][track_file] = TRUE
		if(length(entry["files"]) >= length(enabled_files))
			entry["ready"] = TRUE

/datum/tianguan_sound_board/proc/ready_count(track_file)
	var/ready = 0
	var/total = 0
	for(var/key in status)
		var/client/player = GLOB.directory[key]
		if(!player || QDELETED(player))
			continue
		total++
		var/list/entry = status[key]
		if(entry && entry["files"] && entry["files"][track_file])
			ready++
	return list("ready" = ready, "total" = total)

/datum/tianguan_sound_board/proc/is_fully_ready(track_file)
	var/list/r = ready_count(track_file)
	return r["total"] <= 0 ? FALSE : (r["ready"] >= r["total"])

/datum/tianguan_sound_board/proc/status_table()
	return tianguan_transfer_status_table(status, length(enabled_files), length(queue))

/datum/tianguan_sound_board/proc/play(track_file, client/user)
	var/list/report = tianguan_jukebox_broadcast(track_file, volume)
	if(!report)
		return FALSE
	var/list/track = report["track"]
	playing_file = track_file
	if(play_end_timer)
		deltimer(play_end_timer)
		play_end_timer = null
	var/play_length_ds = max(round(tianguan_jukebox_track_length(track_file) || 0), 0)
	if(play_length_ds)
		play_end_timer = addtimer(CALLBACK(src, PROC_REF(clear_playing)), play_length_ds + 1 SECONDS, TIMER_STOPPABLE)
	log_admin("[key_name(user)] 播放了全局音效面板里的 [track["name"]]（送达 [report["heard"]] 人 / 因音量偏好为 0 跳过 [report["skipped"]] 人）。")
	start_ticking()
	return TRUE

/datum/tianguan_sound_board/proc/clear_playing()
	playing_file = null
	play_end_timer = null

/datum/tianguan_sound_board/proc/stop(client/user)
	tianguan_jukebox_stop_broadcast()
	playing_file = null
	if(play_end_timer)
		deltimer(play_end_timer)
		play_end_timer = null
	if(user)
		log_admin("[key_name(user)] 停止了全局音效面板的播放。")

/datum/tianguan_sound_board/proc/start_ticking()
	if(tick_timer)
		return
	tick_timer = addtimer(CALLBACK(src, PROC_REF(tick)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/tianguan_sound_board/proc/stop_ticking()
	if(tick_timer)
		deltimer(tick_timer)
		tick_timer = null

/datum/tianguan_sound_board/proc/tick()
	register_clients()
	if(!length(GLOB.tianguan_sound_board_uis) && !length(GLOB.tianguan_sound_board_transfer_uis) && !length(queue))
		stop_ticking()
		return
	tianguan_update_ui_list(GLOB.tianguan_sound_board_uis)
	tianguan_update_ui_list(GLOB.tianguan_sound_board_transfer_uis)

// ───────────────────────── 主面板 ─────────────────────────

/client/var/datum/tianguan_sound_board_ui/tianguan_sound_board_ui

/proc/tianguan_sound_board_open(client/user)
	if(!user)
		return
	if(!user.mob)
		to_chat(user, span_warning("面板打不开：这个客户端还没有 mob。"))
		return
	var/datum/tianguan_sound_board_ui/ui_datum = user.tianguan_sound_board_ui
	if(!ui_datum)
		ui_datum = new /datum/tianguan_sound_board_ui(user)
	ui_datum.ui_interact(user.mob)

/datum/tianguan_sound_board_ui
	parent_type = /datum/tianguan_admin_ui
	interface_name = "TianGuanSoundBoard"

/datum/tianguan_sound_board_ui/New(user)
	..()
	if(holder)
		holder.tianguan_sound_board_ui = src

/datum/tianguan_sound_board_ui/get_active_ui_list()
	return GLOB.tianguan_sound_board_uis

/datum/tianguan_sound_board_ui/clear_client_reference()
	if(holder && holder.tianguan_sound_board_ui == src)
		holder.tianguan_sound_board_ui = null

/datum/tianguan_sound_board_ui/on_ui_open(mob/user)
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	board.register_clients()
	board.start_ticking()

/datum/tianguan_sound_board_ui/proc/confirm_remove(client/warner, track_file, track_name)
	var/answer = tgui_alert(warner, "要从服务器上删掉「[track_name]」吗？\n它会同时从点唱机曲库里消失，且不可恢复。", "移除音频", list("删除", "取消"))
	if(answer != "删除")
		return
	var/path = "[CONFIG_JUKEBOX_SOUNDS][track_file]"
	if(!fexists(path))
		to_chat(warner, span_warning("文件已经不在了。"))
		return
	fdel(path)
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	board.enabled_files -= track_file
	board.known_files -= track_file
	for(var/key in board.status)
		var/list/entry = board.status[key]
		if(entry && entry["files"])
			entry["files"] -= track_file
	tianguan_prune_transfer_queue(board.queue, track_file)
	log_admin("[key_name(warner)] 从全局音效面板移除并删除了上传音频 [track_file]。")
	to_chat(warner, span_notice("已删除「[track_name]」。（点唱机曲库同步生效）"))
	board.start_ticking()

/datum/tianguan_sound_board_ui/ui_data(mob/user)
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	var/list/rows = list()
	var/list/files = tianguan_jukebox_catalog()
	for(var/track_file in files)
		var/list/track = files[track_file]
		var/list/ready = board.ready_count(track_file)
		rows += list(list(
			"key" = track_file,
			"name" = track["name"],
			"ready" = ready["ready"],
			"total" = ready["total"],
			"can_play" = board.is_fully_ready(track_file) ? TRUE : FALSE,
			"enabled" = board.enabled_files[track_file] ? TRUE : FALSE,
		))
	return list(
		"volume" = board.volume,
		"interval" = board.interval,
		"playing_file" = board.playing_file,
		"tracks" = rows,
		"summary" = board.status_table(),
	)

/datum/tianguan_sound_board_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!holder || !check_rights_for(holder, R_SOUND))
		return TRUE
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	switch(action)
		if("upload")
			INVOKE_ASYNC(SSadmin_verbs, TYPE_PROC_REF(/datum/controller/subsystem/admin_verbs, dynamic_invoke_verb), holder, /datum/admin_verb/upload_jukebox_music)
			return TRUE
		if("play")
			var/track_file = params["key"]
			if(!board.is_fully_ready(track_file))
				to_chat(holder, span_warning("这首还没给所有在线玩家传输完，稍等一会儿再点。"))
				return TRUE
			board.play(track_file, holder)
			return TRUE
		if("stop")
			board.stop(holder)
			return TRUE
		if("remove")
			var/remove_file = params["key"]
			var/list/remove_track = tianguan_jukebox_catalog()[remove_file]
			if(!remove_track)
				return TRUE
			INVOKE_ASYNC(src, PROC_REF(confirm_remove), holder, remove_file, remove_track["name"])
			return TRUE
		if("transfer")
			var/track_file = params["key"]
			if(board.enabled_files[track_file])
				to_chat(holder, span_notice("这首已经在传输队列里了。"))
				return TRUE
			if(!tianguan_jukebox_catalog()[track_file])
				return TRUE
			board.enabled_files[track_file] = TRUE
			for(var/other_key in board.status)
				board.queue += list(list(other_key, track_file))
			board.start_ticking()
			log_admin("[key_name(holder)] 让 [track_file] 开始给在线玩家传输。")
			return TRUE
		if("set_volume")
			board.volume = clamp(text2num(params["volume"]) || 60, 1, 100)
			return TRUE
		if("set_interval")
			board.interval = clamp(text2num(params["interval"]) || TIANGUAN_SOUND_BOARD_DEFAULT_INTERVAL, 0.5, 60)
			return TRUE
		if("refresh")
			board.register_clients()
			return TRUE
		if("open_transfer")
			var/datum/tianguan_sound_board_transfer_ui/ui_datum = holder?.tianguan_sound_board_transfer_ui
			if(!ui_datum)
				ui_datum = new /datum/tianguan_sound_board_transfer_ui(holder)
			ui_datum.ui_interact(holder.mob)
			board.start_ticking()
			return TRUE

// ───────────────────────── 传输详情窗口 ─────────────────────────

/client/var/datum/tianguan_sound_board_transfer_ui/tianguan_sound_board_transfer_ui

/datum/tianguan_sound_board_transfer_ui
	parent_type = /datum/tianguan_admin_ui
	interface_name = "TianGuanSoundBoardTransfer"

/datum/tianguan_sound_board_transfer_ui/New(user)
	..()
	if(holder)
		holder.tianguan_sound_board_transfer_ui = src

/datum/tianguan_sound_board_transfer_ui/get_active_ui_list()
	return GLOB.tianguan_sound_board_transfer_uis

/datum/tianguan_sound_board_transfer_ui/clear_client_reference()
	if(holder && holder.tianguan_sound_board_transfer_ui == src)
		holder.tianguan_sound_board_transfer_ui = null

/datum/tianguan_sound_board_transfer_ui/on_ui_open(mob/user)
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	board.register_clients()
	board.start_ticking()

/datum/tianguan_sound_board_transfer_ui/ui_data(mob/user)
	var/datum/tianguan_sound_board/board = tianguan_sound_board_controller()
	return list(
		"interval" = board.interval,
		"status" = board.status_table(),
	)

#undef TIANGUAN_SOUND_BOARD_DEFAULT_INTERVAL
