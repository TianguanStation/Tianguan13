// THIS IS A TIANGUAN MODULE FILE
// 模块：admin_countdown —— 管理员「全局倒计时」面板

GLOBAL_DATUM(tianguan_countdown, /datum/tianguan_countdown)

GLOBAL_LIST_EMPTY(tianguan_countdown_uis)
GLOBAL_LIST_EMPTY(tianguan_countdown_transfer_uis)
GLOBAL_LIST_EMPTY(tianguan_countdown_stage_uis)

#define TIANGUAN_CD_IDLE 0
#define TIANGUAN_CD_RUNNING 1
#define TIANGUAN_CD_PAUSED 2
#define TIANGUAN_CD_ENDTEXT 3

/// 屏幕元素：置于 reboot_timer (TOP:-42) 下方，避免回合结束时重叠
/atom/movable/screen/tianguan_countdown
	screen_loc = "CENTER:-140,TOP:-82"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_width = 340
	maptext_height = 64
	maptext = ""
	layer = SCREENTIP_LAYER

/proc/tianguan_countdown_controller()
	RETURN_TYPE(/datum/tianguan_countdown)
	if(!GLOB.tianguan_countdown)
		GLOB.tianguan_countdown = new /datum/tianguan_countdown()
	return GLOB.tianguan_countdown

/// 秘密面板入口：只处理「打开倒计时面板」这一个动作，其余动作交回面板原逻辑。
/proc/tianguan_countdown_ui_act(action, list/params, client/holder)
	if(action != "tianguan_countdown_open" || !holder)
		return FALSE
	var/datum/tianguan_countdown_ui/ui = holder.tianguan_countdown_ui
	if(!ui)
		ui = new /datum/tianguan_countdown_ui(holder)
	ui.ui_interact(holder.mob)
	return TRUE

/datum/tianguan_countdown
	var/state = TIANGUAN_CD_IDLE
	var/title = ""
	var/end_text = ""
	var/remaining = 0
	var/end_remaining = 0
	var/running_deadline = 0
	var/end_deadline = 0
	var/end_seconds = 0
	var/total_seconds = 0
	var/list/title_stages = list()
	var/music_follow_screen = TRUE
	var/music_from_end = TRUE
	var/title_color = "#FFFFFF"
	var/countdown_color = "#FFFFFF"
	var/end_color = "#FFFFFF"
	var/atom/movable/screen/tianguan_countdown/hud
	var/timer_id
	// ── 倒计时音乐（预传输 + 到点播放，实现见 countdown_music.dm）──
	var/silent = FALSE
	var/list/music_selection = list()
	var/music_rate_manual = 0
	var/music_volume = 60
	var/list/music_status = list()
	var/list/music_transfer_queue = list()
	var/music_transfer_timer
	var/music_pushed_total = 0
	var/music_play_index = 0
	var/music_play_timer
	// ── 内部倒计时（放歌准备窗）：与全局倒计时各自独立计时，归零即播放 ──
	var/music_state = TIANGUAN_CD_IDLE
	var/music_remaining = 0
	var/music_deadline = 0
	var/music_duration = 0

/datum/tianguan_countdown/New()
	. = ..()
	hud = new()

/datum/tianguan_countdown/Destroy()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	music_cleanup_transfer()
	music_cleanup_playback()
	for(var/client/player as anything in GLOB.clients)
		player?.screen -= hud
	QDEL_NULL(hud)
	return ..()

/datum/tianguan_countdown/proc/begin(new_title, seconds, new_end_text, new_end_seconds)
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	state = TIANGUAN_CD_RUNNING
	title = new_title || ""
	remaining = max(round(seconds), 1) * 10
	end_text = new_end_text || ""
	end_seconds = max(round(new_end_seconds), 0)
	end_remaining = end_seconds * 10
	running_deadline = world.time + remaining
	total_seconds = max(round(seconds), 1)
	end_deadline = 0
	start_ticking()
	refresh_all()
	if(music_follow_screen && length(music_selection))
		begin_music(music_duration)
		log_admin("（自动）「跟随全局倒计时一起启动」带起了内部倒计时（音乐时长 [music_duration] 秒，口径：[music_from_end ? "距全局倒计时结束" : "从开始算"]）。")
	else if(music_follow_screen)
		log_admin("（自动）跟随已勾选，但没有选中任何曲目 ⇒ 未启动内部倒计时。")

/datum/tianguan_countdown/proc/toggle_pause()
	if(state == TIANGUAN_CD_RUNNING)
		remaining = max(running_deadline - world.time, 0)
		running_deadline = 0
		state = TIANGUAN_CD_PAUSED
	else if(state == TIANGUAN_CD_PAUSED)
		running_deadline = world.time + remaining
		state = TIANGUAN_CD_RUNNING
	else
		return
	refresh_all()

/datum/tianguan_countdown/proc/reset_screen()
	state = TIANGUAN_CD_IDLE
	title = ""
	end_text = ""
	remaining = 0
	end_remaining = 0
	end_seconds = 0
	running_deadline = 0
	end_deadline = 0
	if(hud)
		hud.maptext = ""
	for(var/client/player as anything in GLOB.clients)
		player?.screen -= hud

/datum/tianguan_countdown/proc/stop()
	reset_screen()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	// Intentionally keep music_selection so follow-screen works on next start.
	music_status = list()
	music_pushed_total = 0
	music_state = TIANGUAN_CD_IDLE
	music_remaining = 0
	music_deadline = 0
	music_cleanup_transfer()

/// 颜色校验：只接受 #RGB/#RGBA/#RRGGBB/#RRGGBBAA 或常用色名，避免把任意文本拼进 HTML。
/proc/tianguan_countdown_sanitize_color(color)
	if(!istext(color))
		return "#FFFFFF"
	color = lowertext(trim(color))
	if(!length(color))
		return "#FFFFFF"
	if(copytext(color, 1, 2) == "#")
		var/body = copytext(color, 2)
		if(!(length(body) in list(3, 4, 6, 8)))
			return "#FFFFFF"
		for(var/index in 1 to length(body))
			if(!findtext("0123456789abcdef", copytext(body, index, index + 1)))
				return "#FFFFFF"
		return color
	if(color in list("white", "black", "red", "green", "blue", "yellow", "orange", "purple", "pink", "cyan", "gray", "grey", "gold", "silver", "maroon", "navy", "teal", "olive", "lime", "aqua", "fuchsia"))
		return color
	return "#FFFFFF"

/datum/tianguan_countdown/proc/set_color_by_kind(color_kind, new_color)
	var/safe = tianguan_countdown_sanitize_color(new_color)
	switch(color_kind)
		if("title")
			title_color = safe
		if("countdown")
			countdown_color = safe
		if("end")
			end_color = safe
		else
			return
	refresh_all()

/datum/tianguan_countdown/proc/get_color(color_kind)
	switch(color_kind)
		if("title")
			return title_color
		if("countdown")
			return countdown_color
		if("end")
			return end_color
	return "#FFFFFF"

/datum/tianguan_countdown/proc/set_title(new_title)
	title = new_title || ""
	refresh_all()

/datum/tianguan_countdown/proc/set_end_text(new_text)
	end_text = new_text || ""
	refresh_all()

/datum/tianguan_countdown/proc/start_ticking()
	if(timer_id)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(tick)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/datum/tianguan_countdown/proc/tick()
	if(state == TIANGUAN_CD_IDLE && music_state == TIANGUAN_CD_IDLE)
		if(timer_id)
			deltimer(timer_id)
			timer_id = null
		return
	if(state == TIANGUAN_CD_RUNNING)
		remaining = max(running_deadline - world.time, 0)
		if(length(music_selection) && remaining > 0)
			music_register_online_players()
		if(remaining <= 0)
			if(end_text && end_seconds > 0)
				state = TIANGUAN_CD_ENDTEXT
				end_remaining = end_seconds * 10
				end_deadline = world.time + end_remaining
			else
				reset_screen()
				if(music_state == TIANGUAN_CD_IDLE)
					return
	else if(state == TIANGUAN_CD_ENDTEXT)
		end_remaining = max(end_deadline - world.time, 0)
		if(end_remaining <= 0)
			reset_screen()
			if(music_state == TIANGUAN_CD_IDLE)
				return
	if(music_state == TIANGUAN_CD_RUNNING)
		music_remaining = max(music_deadline - world.time, 0)
		if(length(music_selection) && music_remaining > 0)
			music_register_online_players()
		if(music_remaining <= 0)
			music_play()
			music_state = TIANGUAN_CD_IDLE
			music_remaining = 0
			music_deadline = 0
	refresh_all()
	tianguan_update_ui_list(GLOB.tianguan_countdown_uis)
	tianguan_update_ui_list(GLOB.tianguan_countdown_transfer_uis)
	tianguan_update_ui_list(GLOB.tianguan_countdown_stage_uis)

/datum/tianguan_countdown/proc/refresh_all()
	if(silent || state == TIANGUAN_CD_IDLE)
		for(var/client/player as anything in GLOB.clients)
			if(QDELETED(player))
				continue
			player.screen -= hud
		if(hud)
			hud.maptext = ""
		return
	for(var/client/player as anything in GLOB.clients)
		if(QDELETED(player))
			continue
		if(!(hud in player.screen))
			player.screen += hud
	if(hud)
		hud.maptext = build_maptext()

/datum/tianguan_countdown/proc/build_maptext()
	if(silent || state == TIANGUAN_CD_IDLE)
		return ""
	var/font_open = "<span style='font-family: \"Fusion Pixel 12px Mono zh_hans\"; font-size: 9pt; line-height: 1.25; -dm-text-outline: 1px black'>"
	if(state == TIANGUAN_CD_ENDTEXT)
		return "[font_open]<center><span style='color: [end_color]'>[html_encode(end_text)]</span></center></span>"
	var/list/lines = list()
	var/shown_title = current_title()
	if(shown_title)
		lines += "<span style='color: [current_title_color()]'>[html_encode(shown_title)]</span>"
	if(state == TIANGUAN_CD_PAUSED)
		lines += "<span style='color: [countdown_color]'>已暂停 [DisplayTimeText(remaining, 1)]</span>"
	else
		lines += "<span style='color: [countdown_color]'>[DisplayTimeText(remaining, 1)]</span>"
	return "[font_open]<center>[lines.Join("\n")]</center></span>"

// ───────────────────────── 管理员界面（TGUI：TianGuanCountdown） ─────────────────────────

/client/var/datum/tianguan_countdown_ui/tianguan_countdown_ui

/datum/tianguan_countdown_ui
	parent_type = /datum/tianguan_admin_ui
	interface_name = "TianGuanCountdown"

/datum/tianguan_countdown_ui/New(user)
	..()
	if(holder)
		holder.tianguan_countdown_ui = src

/datum/tianguan_countdown_ui/get_active_ui_list()
	return GLOB.tianguan_countdown_uis

/datum/tianguan_countdown_ui/clear_client_reference()
	if(holder && holder.tianguan_countdown_ui == src)
		holder.tianguan_countdown_ui = null

/datum/tianguan_countdown_ui/proc/pick_color(client/picker, color_kind)
	var/static/list/color_labels = list("title" = "标题", "countdown" = "倒计时", "end" = "结束文本")
	if(!(color_kind in color_labels))
		return
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	var/picked = tgui_color_picker(picker, "选择[color_labels[color_kind]]颜色", "全局倒计时 · 取色", countdown.get_color(color_kind))
	if(!picked)
		return
	countdown.set_color_by_kind(color_kind, picked)
	log_admin("[key_name(picker)] 用取色器改了全局倒计时的[color_labels[color_kind]]颜色（[countdown.get_color(color_kind)]）。")
	SStgui.update_uis(src)

/datum/tianguan_countdown_ui/ui_data(mob/user)
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	return list(
		"state" = countdown.state,
		"title" = countdown.title,
		"end_text" = countdown.end_text,
		"remaining" = countdown.remaining,
		"end_seconds" = countdown.end_seconds,
		"title_color" = countdown.title_color,
		"countdown_color" = countdown.countdown_color,
		"end_color" = countdown.end_color,
		"silent" = countdown.silent,
		"music_catalog" = tianguan_jukebox_catalog_options(),
		"music_selection" = countdown.music_selection,
		"music_rate_manual" = countdown.music_rate_manual,
		"music_volume" = countdown.music_volume,
		"music_interval" = countdown.music_interval_seconds(),
		"music_status" = countdown.music_status_table(),
		"music_state" = countdown.music_state,
		"music_remaining" = countdown.music_remaining / 10,
		"music_duration" = countdown.music_duration,
		"music_delta" = (countdown.music_remaining - countdown.remaining) / 10,
		"music_follow_screen" = countdown.music_follow_screen,
		"music_from_end" = countdown.music_from_end,
	)

/datum/tianguan_countdown_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!check_rights(R_ADMIN))
		return
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	switch(action)
		if("start")
			var/seconds = text2num(params["seconds"])
			var/end_seconds = text2num(params["end_seconds"])
			if(isnull(seconds))
				seconds = 60
			if(isnull(end_seconds))
				end_seconds = 0
			if(countdown.music_follow_screen && !length(countdown.music_selection))
				INVOKE_ASYNC(src, PROC_REF(alert_no_songs), holder)
			countdown.begin(params["title"], clamp(seconds, 1, 24 HOURS / 10), params["end_text"], clamp(end_seconds, 0, 1 HOURS / 10))
			log_admin("[key_name(holder)] 启动了全局倒计时（[clamp(seconds, 1, 24 HOURS / 10)] 秒）。")
		if("pause")
			countdown.toggle_pause()
			log_admin("[key_name(holder)] [countdown.state == TIANGUAN_CD_PAUSED ? "暂停" : "继续"]了全局倒计时。")
		if("stop")
			countdown.stop()
			log_admin("[key_name(holder)] 结束了全局倒计时。")
		if("set_title")
			countdown.set_title(params["title"])
			log_admin("[key_name(holder)] 更改了全局倒计时的标题。")
		if("set_end_text")
			countdown.set_end_text(params["end_text"])
			log_admin("[key_name(holder)] 更改了全局倒计时的结束文本。")
		if("set_title_color")
			countdown.set_color_by_kind("title", params["title_color"])
			log_admin("[key_name(holder)] 更改了全局倒计时的标题颜色（[countdown.title_color]）。")
		if("set_countdown_color")
			countdown.set_color_by_kind("countdown", params["countdown_color"])
			log_admin("[key_name(holder)] 更改了全局倒计时的倒计时颜色（[countdown.countdown_color]）。")
		if("set_end_color")
			countdown.set_color_by_kind("end", params["end_color"])
			log_admin("[key_name(holder)] 更改了全局倒计时的结束文本颜色（[countdown.end_color]）。")
		if("pick_title_color")
			INVOKE_ASYNC(src, PROC_REF(pick_color), holder, "title")
		if("pick_countdown_color")
			INVOKE_ASYNC(src, PROC_REF(pick_color), holder, "countdown")
		if("pick_end_color")
			INVOKE_ASYNC(src, PROC_REF(pick_color), holder, "end")
		if("set_silent")
			countdown.silent = !!params["silent"]
			countdown.refresh_all()
			log_admin("[key_name(holder)] 把全局倒计时设为[countdown.silent ? "纯准备（静默）" : "正常显示"]模式。")
		if("set_music")
			var/list/requested = params["selection"]
			if(!islist(requested))
				requested = list()
			var/list/catalog = tianguan_jukebox_catalog()
			var/list/accepted = list()
			for(var/song in requested)
				if(catalog[song])
					accepted += song
			countdown.music_selection = accepted
			log_admin("[key_name(holder)] 选了 [length(accepted)] 首倒计时曲目（收到 [length(requested)] 条）。")
		if("set_music_rate")
			var/rate = text2num(params["rate"])
			countdown.music_rate_manual = clamp(isnull(rate) ? 0 : rate, 0, 600)
			log_admin("[key_name(holder)] 把倒计时传输节奏设为[countdown.music_rate_manual ? "[countdown.music_rate_manual] 秒/首" : "自动"]。")
		if("set_music_volume")
			var/vol = text2num(params["volume"])
			countdown.music_volume = clamp(isnull(vol) ? 60 : vol, 1, 100)
			log_admin("[key_name(holder)] 把倒计时音乐音量设为 [countdown.music_volume]。")
		if("set_music_duration")
			var/duration = text2num(params["seconds"])
			countdown.music_duration = clamp(isnull(duration) ? 0 : round(duration), 0, 36000)
		if("start_music")
			var/music_seconds = text2num(params["music_seconds"])
			if(!length(countdown.music_selection))
				INVOKE_ASYNC(src, PROC_REF(alert_no_songs), holder)
				return TRUE
			countdown.begin_music(isnull(music_seconds) ? 60 : music_seconds)
			log_admin("[key_name(holder)] 启动了内部倒计时（放歌准备窗）：[countdown.music_duration] 秒。")
		if("stop_music")
			countdown.stop_music()
			log_admin("[key_name(holder)] 停止了内部倒计时。")
		if("set_follow")
			countdown.music_follow_screen = !!params["follow"]
			log_admin("[key_name(holder)] 把「跟随全局倒计时一起启动」设为 [countdown.music_follow_screen ? "开" : "关"]。")
		if("set_from_end")
			countdown.music_from_end = !!params["from_end"]
			log_admin("[key_name(holder)] 把音乐时长的口径设为[countdown.music_from_end ? "按「距全局倒计时结束」" : "按「从开始算」"]。")
		if("preview_music")
			tianguan_jukebox_preview(holder?.mob, params["song"], countdown.music_volume)
		if("upload_music")
			if(!check_rights(R_SERVER, FALSE))
				return
			INVOKE_ASYNC(SSadmin_verbs, TYPE_PROC_REF(/datum/controller/subsystem/admin_verbs, dynamic_invoke_verb), holder, /datum/admin_verb/upload_jukebox_music)
		if("refresh_music")
			. = TRUE
		if("open_transfer")
			var/datum/tianguan_countdown_transfer_ui/window = holder.tianguan_countdown_transfer_ui
			if(!window)
				window = new /datum/tianguan_countdown_transfer_ui(holder)
			window.ui_interact(holder.mob)
			. = TRUE
		if("open_stages")
			var/datum/tianguan_countdown_stage_ui/editor = holder.tianguan_countdown_stage_ui
			if(!editor)
				editor = new /datum/tianguan_countdown_stage_ui(holder)
			editor.ui_interact(holder.mob)
			. = TRUE
	return TRUE

/datum/tianguan_countdown/proc/sort_title_stages()
	var/list/sorted = title_stages.Copy()
	for(var/i in 2 to length(sorted))
		var/list/key = sorted[i]
		var/j = i - 1
		while(j >= 1 && sorted[j]["at"] > key["at"])
			sorted[j + 1] = sorted[j]
			j--
		sorted[j + 1] = key
	return sorted

// ───────────────────────── 标题阶段编辑器（TGUI：TianGuanCountdownStages） ─────────────────────────

/client/var/datum/tianguan_countdown_stage_ui/tianguan_countdown_stage_ui

/datum/tianguan_countdown_stage_ui
	parent_type = /datum/tianguan_admin_ui
	interface_name = "TianGuanCountdownStages"

/datum/tianguan_countdown_stage_ui/New(user)
	..()
	if(holder)
		holder.tianguan_countdown_stage_ui = src

/datum/tianguan_countdown_stage_ui/get_active_ui_list()
	return GLOB.tianguan_countdown_stage_uis

/datum/tianguan_countdown_stage_ui/clear_client_reference()
	if(holder && holder.tianguan_countdown_stage_ui == src)
		holder.tianguan_countdown_stage_ui = null

/datum/tianguan_countdown_stage_ui/ui_data(mob/user)
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	return list(
		"base_title" = countdown.title,
		"total_seconds" = countdown.total_seconds,
		"state" = countdown.state,
		"elapsed" = countdown.elapsed_seconds(),
		"current" = countdown.current_title(),
		"stages" = countdown.title_stages,
	)

/datum/tianguan_countdown_stage_ui/proc/pick_stage_color(client/picker, index)
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	if(!index || index < 1 || index > length(countdown.title_stages))
		return
	var/list/stage = countdown.title_stages[index]
	var/picked = tgui_color_picker(picker, "选择该阶段标题颜色", "标题阶段 · 取色", stage["color"] || countdown.title_color)
	if(!picked)
		return
	stage["color"] = tianguan_countdown_sanitize_color(picked)
	SStgui.update_uis(src)

/datum/tianguan_countdown_stage_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/tianguan_countdown/countdown = tianguan_countdown_controller()
	switch(action)
		if("add_stage")
			var/next_at = 60
			if(length(countdown.title_stages))
				var/list/last_stage = countdown.title_stages[length(countdown.title_stages)]
				next_at = last_stage["at"] + 60
			countdown.title_stages += list(list("at" = next_at, "text" = "", "color" = null))
			countdown.title_stages = countdown.sort_title_stages()
			. = TRUE
		if("set_stage")
			var/index = text2num(params["index"])
			if(!index || index < 1 || index > length(countdown.title_stages))
				return
			var/list/stage = countdown.title_stages[index]
			if(!isnull(params["at"]))
				stage["at"] = max(round(text2num(params["at"])), 0)
			if(!isnull(params["text"]))
				stage["text"] = "[params["text"]]"
			if(!isnull(params["color"]))
				stage["color"] = tianguan_countdown_sanitize_color("[params["color"]]")
			countdown.title_stages = countdown.sort_title_stages()
			. = TRUE
		if("pick_stage_color")
			var/index = text2num(params["index"])
			if(index && index >= 1 && index <= length(countdown.title_stages))
				INVOKE_ASYNC(src, PROC_REF(pick_stage_color), holder, index)
			. = TRUE
		if("remove_stage")
			var/index = text2num(params["index"])
			if(index && index >= 1 && index <= length(countdown.title_stages))
				countdown.title_stages.Cut(index, index + 1)
			. = TRUE
		if("clear_stages")
			countdown.title_stages = list()
			. = TRUE

/datum/tianguan_countdown/proc/current_stage()
	if(!length(title_stages))
		return null
	var/elapsed = elapsed_seconds()
	var/list/picked = null
	for(var/list/stage as anything in title_stages)
		if(stage["at"] > elapsed)
			break
		picked = stage
	return picked

/datum/tianguan_countdown/proc/elapsed_seconds()
	return max(total_seconds - round(remaining / 10), 0)

/datum/tianguan_countdown/proc/current_title()
	var/list/stage = current_stage()
	if(!stage || isnull(stage["text"]))
		return title
	return stage["text"]

/datum/tianguan_countdown/proc/current_title_color()
	var/list/stage = current_stage()
	if(!stage || !stage["color"])
		return title_color
	return stage["color"]

/datum/tianguan_countdown_ui/proc/alert_no_songs(client/warner)
	tgui_alert(warner, "倒计时播放相关的设置已开启，但没有勾选任何曲目 ⇒ 到点不会播放。\n请到面板下方「曲目与传输」里勾选至少一首。", "倒计时音乐")
