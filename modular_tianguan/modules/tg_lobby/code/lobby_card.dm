/// 天关大厅侧边栏「角色卡」——头像 + 偏好摘要 + 变化推送。
/// 适配 SPLURT-zh 的 title_browser 与多套配装预设（loadout_index）。

#define TG_LOBBY_AVATAR_DIRS SOUTH
#define TG_LOBBY_WATCH_INTERVAL (2 SECONDS)

/mob/dead/new_player
	/// 大厅配装轮询是否已启动（防止重复开循环）
	var/tg_lobby_watch_running = FALSE
	/// 上一次的监听指纹，只在变化时才重算头像
	var/tg_last_watch_fingerprint

/// 生成侧边栏角色头像（复用角色设置预览渲染，并缩放到 64x64 降低锯齿）。
/datum/preferences/proc/tg_lobby_avatar_icon()
	var/mob/living/carbon/human/dummy/mannequin = new
	var/mannequin_appearance = render_new_preview_appearance(mannequin)
	var/icon/avatar = getFlatIcon(mannequin_appearance, TG_LOBBY_AVATAR_DIRS, no_anim = TRUE)
	SSatoms.prepare_deletion(mannequin)
	avatar?.Scale(64, 64)
	return avatar

/// 侧边栏偏好摘要（键值行 HTML 片段）。
/datum/preferences/proc/tg_lobby_prefs_html()
	var/datum/species/selected_species = read_preference(/datum/preference/choiced/species)
	var/gender_value = read_preference(/datum/preference/choiced/gender)
	var/gender_text = "其他"
	if(gender_value == MALE)
		gender_text = "男"
	else if(gender_value == FEMALE)
		gender_text = "女"
	var/datum/job/highest_job = get_highest_priority_job()
	var/job_title = highest_job?.title
	if(!job_title)
		job_title = "无"

	var/list/rows = list(
		list("种族", html_encode(selected_species?.name || "未知")),
		list("年龄", "[read_preference(/datum/preference/numeric/age)]"),
		list("性别", gender_text),
		list("职位", html_encode(job_title)),
	)
	var/result = ""
	for(var/list/row in rows)
		result += {"<div class="tg_prow"><span class="k">[row[1]]</span><span class="v">[row[2]]</span></div>"}
	return result

/// 将 & 替换为安全占位符，避免 BYOND output() 按 & 拆分参数；由前端 JS 还原。
/proc/tg_escape_output_amp(text)
	return replacetext(text, "&", "__TGAMP__")

/// 侧边栏角色卡（头像 + 名字 + ID + 槽位 + 偏好）的初始 HTML。
/mob/dead/new_player/proc/tg_lobby_card_html()
	if(!client || !client.prefs)
		return ""

	RegisterSignal(src, COMSIG_JOB_PREF_UPDATED, PROC_REF(tg_on_job_pref_updated), override = TRUE)
	tg_start_lobby_watch()

	var/datum/preferences/prefs = client.prefs
	var/icon/avatar = prefs.tg_lobby_avatar_icon()
	var/avatar_tag = {"<img id="tg_avatar" class="tg_avatar" src="data:image/png;base64,[icon2base64(avatar)]" alt="">"}
	var/name_text = html_encode(uppertext(prefs.read_preference(/datum/preference/name/real_name)))

	return {"
		<div class="tg_card">
			[avatar_tag]
			<div class="tg_pname" id="tg_pname">[name_text]</div>
			<div class="tg_pid" id="tg_pid">ID: [html_encode(client.ckey)] &nbsp;·&nbsp; 槽位 [prefs.default_slot]</div>
		</div>
		<div class="tg_prefs" id="tg_prefs">[prefs.tg_lobby_prefs_html()]</div>
	"}

/mob/dead/new_player/proc/tg_on_job_pref_updated(datum/source, ...)
	SIGNAL_HANDLER
	if(client)
		INVOKE_ASYNC(client, TYPE_PROC_REF(/client, tg_push_lobby_card), "job_pref_signal")

/mob/dead/new_player/proc/tg_start_lobby_watch()
	if(tg_lobby_watch_running)
		return
	tg_lobby_watch_running = TRUE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/dead/new_player, tg_lobby_watch_loop))

/mob/dead/new_player/proc/tg_lobby_watch_loop()
	set waitfor = FALSE
	while(!QDELETED(src) && client)
		sleep(TG_LOBBY_WATCH_INTERVAL)
		if(!client?.prefs?.character_preview_view)
			continue
		var/fingerprint = client.prefs.tg_lobby_watch_fingerprint()
		if(fingerprint == tg_last_watch_fingerprint)
			continue
		tg_last_watch_fingerprint = fingerprint
		INVOKE_ASYNC(client, TYPE_PROC_REF(/client, tg_push_lobby_card), "watch_poll")

/// 监听指纹：多套配装预设、当前选用预设名、职业优先级。
/datum/preferences/proc/tg_lobby_watch_fingerprint()
	return json_encode(list(
		read_preference(/datum/preference/loadout),
		read_preference(/datum/preference/loadout_index),
		job_preferences,
	))

/// 推送最新角色卡数据到 SPLURT 的 title_browser 窗口。
/client/proc/tg_push_lobby_card(reason = "unknown")
	var/mob/dead/new_player/player = mob
	if(!istype(player) || !prefs)
		return

	var/name_text = uppertext(prefs.read_preference(/datum/preference/name/real_name))
	var/prefs_html = prefs.tg_lobby_prefs_html()
	var/icon/avatar = prefs.tg_lobby_avatar_icon()

	src << output(icon2base64(avatar), "title_browser:tg_set_avatar")
	src << output(tg_escape_output_amp(prefs_html), "title_browser:tg_set_prefs")
	src << output(tg_escape_output_amp(name_text), "title_browser:tg_set_name")
	src << output(tg_escape_output_amp("ID: [key] · 槽位 [prefs.default_slot]"), "title_browser:tg_set_pid")
	src << output(tg_escape_output_amp(name_text), "title_browser:update_current_character")
	player.tg_last_watch_fingerprint = prefs.tg_lobby_watch_fingerprint()

/datum/preference_middleware/tianguan_lobby

/datum/preference_middleware/tianguan_lobby/on_new_character(mob/user)
	. = ..()
	if(!istype(user, /mob/dead/new_player))
		return
	if(user.client)
		INVOKE_ASYNC(user.client, TYPE_PROC_REF(/client, tg_push_lobby_card), "new_character")

/datum/preference_middleware/tianguan_lobby/post_set_preference(mob/user, preference, value)
	. = ..()
	if(!istype(user, /mob/dead/new_player) || !user.client)
		return
	var/datum/preference/pref_entry = GLOB.preference_entries_by_key?[preference]
	if(pref_entry && pref_entry.savefile_identifier != PREFERENCE_CHARACTER)
		return
	INVOKE_ASYNC(user.client, TYPE_PROC_REF(/client, tg_push_lobby_card), "pref:[preference]")

#undef TG_LOBBY_AVATAR_DIRS
#undef TG_LOBBY_WATCH_INTERVAL
